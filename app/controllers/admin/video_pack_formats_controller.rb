class Admin::VideoPackFormatsController < Admin::BaseController
  
  active_scaffold :video_pack_formats do |config|
    config.columns = [:video_pack, :format, :details, :is_downloadable, :price]

    config.columns[:video_pack].form_ui = :select

    config.list.columns = [:video_pack, :format, :is_downloadable, :price]
  end
end
