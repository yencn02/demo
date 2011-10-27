class VideoPack < ActiveRecord::Base
  slugify :title

  validates_presence_of :title, :slug, :description, :image, :videos

  has_attached_file :image, 
                    :styles => { :thumb => '90>x60', :medium => '180>x120', :large => '200>x133'},
                    :default_url => "/images/sample-image.jpg"
  has_and_belongs_to_many :videos, :join_table => "video_pack_videos"
  has_many :formats, :class_name => "VideoPackFormat", :dependent => :delete_all
  before_save :save_published_at
  

  def save_published_at
    self.published_at = Time.now unless self.published_at
  end

  named_scope :must_has_formats, :include => :formats, :conditions => ["video_pack_formats.id is not null"]

  named_scope :by_filter, proc { |filter| 
    case filter.to_s
    when '', 'recent'
      { :order => 'published_at DESC' }
    when 'popular'
      { :order => 'purchase_count DESC' }
    when 'viewed'
      { :order => 'view_count DESC' }
    when 'featured'
      { :conditions => { :is_featured => true } }
    end
  }

  named_scope :of_category, proc { |category|
    if category = Category.first(:include => :categorizables, :conditions => {:name => category})
      {
        :conditions => {
          :id => category.categorizables.all(:select => 'categorized_id', :conditions => {
              :categorized_type => 'VideoPack'
            }).collect(&:categorized_id)
        }
      }
    end
  }

  def get_video_format(format_id)
    self.formats.first(:conditions => {:video_pack_id => self.id, :format_id => format_id})
  end

  class << self
    def with_search(query = nil)
      query.blank? ? title_or_description_like('') : title_or_description_like(query)
    end

    def browse_by(filter, category, query, page)
      by_filter(filter).of_category(category).must_has_formats.with_search(query).paginate(:page => page)
    end

    def feature_items(limit)
      self.find(:all, :conditions => {:is_featured => true},:limit => limit, :order => "created_at DESC")
    end
  end


  def update_view_count
    self.view_count +=1
    self.save
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

  def duration_in_seconds
    videos.collect(&:duration_in_seconds).sum
  end

  def average_duration
    size = videos.size
    if size > 2
      average = duration_in_seconds/size
      average - (average % 60)
    else
      duration_in_seconds
    end
  end

  def categories
    cats = []
    videos.each do |video|
      video.categories.collect { |cat| cats << cat.name }
    end
    cats.uniq
  end

  def playlist
    track = []    
    self.videos.each do |video|      
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
