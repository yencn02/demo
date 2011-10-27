class VideoPackFormat < ActiveRecord::Base
  validates_presence_of :format, :video_pack, :price
  validates_uniqueness_of :format_id, :scope => :video_pack_id
  belongs_to :video_pack, :class_name => "VideoPack", :foreign_key => "video_pack_id"
  belongs_to :format
  has_one :price, :as => :product

  def title
    "#{video_pack.title} - #{name}"
  end

  def description
    video_pack.description
  end

  def name
    format.name
  end
  
  def product_code
    "VDO-PK-#{video_pack.id}-#{self.id}"
  end

  def to_label
    "#{video_pack.title} - #{name} (Pack)"
  end

  def validate
    if self.video_pack && self.format
      self.video_pack.videos.each do |video|
        unless video.get_video_format(self.format_id)
          errors.add_to_base("A video in pack (video #{video.title}) does not have format #{self.format.name}")
        end
      end
    end
  end

end