module Admin::VideoPacksHelper
  def options_for_association_conditions(association)
    if association.name == :videos
      videos = Video.all(:select => "videos.id",
        :include => :formats,
        :conditions => ["video_formats.id is not null"])
      ["id in (?) and is_demo = 0", videos]
    else
      super
    end
  end
end
