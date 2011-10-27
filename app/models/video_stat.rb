class VideoStat < ActiveRecord::Base
  validates_presence_of :video

  belongs_to :video, :counter_cache => :view_count
end
