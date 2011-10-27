class Admin::VideoPacksController < Admin::BaseController
  
  active_scaffold :video_packs do |config|
    config.columns = [:image, :title, :description, :is_featured, :videos]

    config.columns[:videos].form_ui = :select
    config.columns[:videos].options = {
      :draggable_lists => false
    }

    config.list.columns = [:id, :image, :title, :description, :is_featured]
    config.nested.add_link('View all Formats', [:formats])

  end
end
