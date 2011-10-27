class Admin::VideoFormatsController < Admin::BaseController
  
  active_scaffold :video_formats do |config|
    config.columns = [:video, :format, :details, :is_downloadable, :cdn_url, :acutrack_sku, :price]
    config.columns[:video].form_ui = :select
    config.list.columns = [:video, :format, :details, :is_downloadable, :cdn_url]
  end
end
