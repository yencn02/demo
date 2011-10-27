class Admin::VideosController < Admin::BaseController
  layout 'admin'
  include ActiveScaffold::Finder::ClassMethods
  active_scaffold :videos do |config|
    config.columns = [:image, :demo_url, :title, :description, :duration_in_seconds, :is_demo, :featured_home, :is_featured, :trails]
    config.list.columns = [:id, :image, :title, :description, :duration_in_seconds, :is_featured, :featured_home]
    config.nested.add_link('View all Formats', [:formats], :html_options => {:class => "view_all_formats"})
    config.action_links.add 'list', :label => 'Product Videos', :parameters =>{:controller=>'admin/videos',:is_demo => 0}, :html_options=>{:class => "product_videos"}
    config.action_links.add 'list', :label => 'Demo Videos', :parameters =>{:controller=>'admin/videos',:is_demo => 1}, :html_options=>{:class => "demo_videos"}
  end
end
