class VideoFormat < ActiveRecord::Base
  validates_presence_of :format, :video, :price
  validates_uniqueness_of :format_id, :scope => :video_id
  before_destroy :validate_before_destroy

#  validate_on_create do |video_format|
#    if video_format.is_downloadable? and !video_format.download.file?
#      video_format.errors.add :download, 'must be a valid file'
#    end
#  end

  belongs_to :format
  has_attached_file :download
  belongs_to :video, :class_name => "Video", :foreign_key => "video_id"
  has_one :price, :as => :product

  def title
    "#{video.title} - #{name}"
  end

  def description
    video.description
  end

  def name
    format.name
  end

  def product_code
    "VDO-#{video.id}-#{self.id}"
  end

  def url
    time = Time.now.to_i + 24 * 60 * 60
    md5 = "#{SECRET_KEY}#{URL_STORE}#{self.cdn_url.to_s.strip}?e=#{time}"
    hash = Digest::MD5.hexdigest(md5)
    "#{URL_STORE}#{self.cdn_url.to_s.strip}?e=#{time}&h=#{hash}"
  end

  def url_download   
    end_time = (Time.now + 24 * 1 * 60 * 60).to_i
    url = "#{SECRET_KEY}#{URL_STORE}#{self.cdn_url.to_s.strip}?e=#{end_time}"
    h = Digest::MD5.hexdigest(url)
    "#{URL_STORE}#{self.cdn_url.to_s.strip}?e=#{end_time}&h=#{h}"
  end

  def validate_on_update
    old_obj = VideoFormat.find(self.id)
    self.video.video_packs.each do |pack|
      if pack.get_video_format(old_obj.format_id)
        errors.add_to_base("Can't change format from #{old_obj.format.name} to #{self.format.name}, because of existing a pack that contains this video with format #{old_obj.format.name}")
      end
    end
  end

  def validate_before_destroy
    self.video.video_packs.each do |pack|
      if pack.get_video_format(self.format_id)
        errors.add_to_base("Can't delete this video format, because of existing a pack that contains this video with the same format")
        return false
      end
    end
    return true
  end

  def to_label
    "#{self.video.title} - #{self.format.name}"
  end
end
