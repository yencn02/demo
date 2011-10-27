require 'digest/md5'
class Video < ActiveRecord::Base

  cattr_reader :per_page
  @@per_page = 5

  slugify :title

  validates_presence_of :title, :slug, :description, :demo_url
  before_destroy :validate_before_destroy
  has_attached_file :image, 
                    :styles => { :thumb => '90>x60', :medium => '180>x120', :large => '200>x133'},
                    :default_url => "/images/sample-image.jpg"
  before_save :validate_before_save
  has_and_belongs_to_many :video_packs, :join_table => "video_pack_videos"
  has_many :categorizables, :as => :categorized, :include => :category
  has_many :formats, :class_name => "VideoFormat", :dependent => :delete_all
  has_many :trails

  named_scope :by_filter, proc { |filter| 
    case filter.to_s
    when '', 'recent'
      { :order => 'published_at DESC' }
    when 'popular'
      { :order => 'purchase_count DESC' }
    when 'viewed'
      { :order => 'view_count DESC' }
    when 'featured'
      { :conditions => { :is_featured => true, :is_demo => false} }
    end
  }

  named_scope :demo_video, proc {|boolean|
    { :conditions => {:is_demo => boolean} }
  }

  named_scope :must_has_formats, :include => :formats, :conditions => ["video_formats.id is not null"]

  named_scope :of_category, proc { |category|
    if category = Category.first(:include => :categorizables, :conditions => {:name => category})
      {
        :conditions => {
          :id => category.categorizables.all(:select => 'categorized_id', :conditions => {
              :categorized_type => 'Video'
            }).collect(&:categorized_id)
        }
      }
    end
  }

  def validate_before_save
    unless self.published_at
      self.published_at = Time.now
    end
    if self.featured_home == true
      self.is_demo = true
    end
  end

  #  def before_save
  #    if featured_home
  #      video = Video.find_by_featured_home(true)
  #      unless video.nil?
  #        video.featured_home = false
  #        video.save
  #      end
  #    end
  #  end

  def url
    URL_DEMO + self.demo_url unless self.demo_url.nil?
  end

  def update_view_count(ip_address)
    if VideoStat.find(:first, :conditions => {:ip_address => ip_address, :video_id => self.id}).nil?
      video_stat = VideoStat.new
      video_stat.video_id = self.id
      video_stat.ip_address = ip_address
      video_stat.save
    end
  end


  class << self
    def with_search(query = nil)
      query.blank? ? title_or_description_like('') : title_or_description_like(query)
    end

    def within_length(length_range = nil)
      if length_range.to_s =~ /\A-(\d+)/
        duration_in_seconds_lte($1.to_i * 60)
      elsif length_range.to_s =~ /(\d+)-\Z/
        duration_in_seconds_gte($1.to_i * 60)
      elsif length_range.to_s =~ /(\d+)-(\d+)/
        duration_in_seconds_gte($1.to_i * 60).duration_in_seconds_lte($2.to_i * 60)
      else
        duration_in_seconds_gte(0)
      end
    end

    def browse_by(filter, category, length, query, page)
      by_filter(filter).of_category(category).must_has_formats.within_length(length).with_search(query).demo_video(false).paginate(:page => page)
    end

    def feature_items(limit)
      self.find(:all, :conditions => {:is_featured => true},:limit => limit, :order => "created_at DESC")
    end

    def playlist(videos)
      track = []
      videos.each do |video|        
        url = video.url unless video.url.blank?
        track << {"title" => video.title, "location" => url, "image" => video.image}
      end
      hash = {
        "playlist" => {
          "trackList" => {"track" => track}
        }
      }
      hash[:attributes!] = { "playlist" => {"version" => "1", "xmlns" => "http://xspf.org/ns/0/" } }
      hash.to_soap_xml
    end
  end

  def categories
    categorizables.collect(&:category).flatten
  end

  def increment_purchase_count!
    update_attribute(:purchase_count, purchase_count + 1)
  end

  def to_param
    "#{id}-#{slug}"
  end

  def image_thumb_path
    image_file_name.blank? ? String.new : image.url(:thumb, include_updated_timestamp = false)
  end

  def image_medium_path
    image_file_name.blank? ? String.new : image.url(:medium, include_updated_timestamp = false)
  end

  def image_large_path
    image_file_name.blank? ? String.new : image.url(:large, include_updated_timestamp = false)
  end

  def purchased?(user)
    unless user
      false
    else
      orders = user.account.orders.all(:select => :id)
      purchased_as_format?(orders) == true ? true : purchased_in_pack?(orders)
    end
  end

  def purchased_as_format?(orders)
    items = OrderedLineItem.all(:conditions => {
        :order_id => orders.map{|x| x.id},
        :product_id => formats.map{|x| x.id},
        :product_type => "VideoFormat" })
    return items.size == 0 ? false : true
  end

  def purchased_in_pack?(orders)
    video_pack_formats = []
    video_packs.each do |pack|
      video_pack_formats.concat(pack.formats)
    end
    items = OrderedLineItem.all(:conditions => {
        :order_id => orders.map{|x| x.id},
        :product_id => video_pack_formats.map{|x| x.id},
        :product_type => "VideoPackFormat" })
    return items.size == 0 ? false : true
  end

  def get_video_format(format_id)
    self.formats.first(:conditions => {:video_id => self.id, :format_id => format_id})
  end

  def validate_before_destroy
    self.video_packs.each do |pack|
      if pack.get_video_format(self.format_id)
        errors.add_to_base("Existing a pack that contains this video.")
        return false
      end
    end
    return true
  end

end
