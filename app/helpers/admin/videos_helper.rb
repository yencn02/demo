module Admin::VideosHelper
  def js_for_list_videos(is_demo)
    if is_demo && is_demo == "1"
      script = <<-eos
        jQuery('.view_all_formats').hide();
        jQuery('.is_featured-column').hide();
        jQuery('#as_admin__videos-is_featured-column').hide();
        jQuery('.demo_videos').css('background-color', 'yellow');
      eos
    else
      script = <<-eos
        jQuery('.featured_home-column').hide();
        jQuery('#as_admin__videos-featured_home-column').hide();
        jQuery('.product_videos').css('background-color', 'yellow');
      eos
    end
    javascript_tag(script)
  end
end
