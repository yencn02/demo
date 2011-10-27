# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper
  DEFAULT_VIDEO_IMAGE = "/images/sample-image.jpg"
  def current_nav_item(regex, content = '', tag_name = :li, current_class = :current)
    content_tag(tag_name, block_given? ? yield : content, :class => (current_class if request.path =~ regex))
  end

  def cart_image_from(line_item)
    return image_tag( 'video-preview.gif') if line_item.product.respond_to?(:video)
    return image_tag('video-pack-preview.gif') if line_item.product.respond_to?(:videos)
  end

  def video_format_image_for(format)
    case format.name
    when /bluray/i
      image_tag('video-format-bluray.gif')
    when /dvd/i
      image_tag('video-format-dvd.gif')
    when /ipod/i
      image_tag('video-format-ipod.gif')
    when /download/i
      image_tag('video-format-download.gif')
    end
  end

  def video_format_image_source(format)
    case format.name
    when /bluray/i
      'bluray.png'
    when /dvd/i
      'dvd.png'
    when /ipod/i
      'ipod.png'
    when /download/i
      'ipod.png'
    end
  end

  def image_source(source, default_source = DEFAULT_VIDEO_IMAGE)
    if source.blank?
      return default_source
    else
      return source
    end
  end

  def video_categories(video)
    video.categories.collect { |category| link_to category.name, search_path(:category => category.name) }.to_sentence
  end

  def load_states(carmen_states)
    state_options = {"Default" => options_for_select(["", ""])}
    for i in 0...carmen_states.size
      country = carmen_states[i][0]
      states = carmen_states[i][1]
      state_options[country] = options_for_select(states)
    end
    javascript_tag("var states = #{state_options.to_json}")
  end

  def state_from_country(selected_country, selected = ["", ""])
    carmen_states = Carmen::STATES
    for i in 0...carmen_states.size
      country = carmen_states[i][0]
      if country == selected_country
        states = options_for_select carmen_states[i][1], {:selected => selected}
        break
      end
    end
    unless states
      states = options_for_select ["", ""], {:selected => ["", ""]}
    end
    return states
  end

  def country_form_column(record, input)
    country_select :record, :country, "US",{},{:class => "country-input"}
  end

  def state_form_column(record, input)
    selected = [Carmen::state_name(record.state), record.state]
    unless record.country
      record.country = "US"
    end
    states = state_from_country(record.country, selected)
    select(:record, :state, states, {:selected => selected}, {:class => "state-input"})
  end

  def format_order_form_column(record, input)
    number = Format.count + 1
    format_order = Array.new    
    number.times do |n|
      format_order << n unless n == 0    
    end
    if record.name.nil?
      select(:record, :format_order, record.name.nil? ? [number] : format_order, {:style => "display:none;", :selected => record.name.nil? ? [number]: record.format_order})
    else
      select(:record, :format_order, record.name.nil? ? [number] : format_order, {:selected => record.name.nil? ? [number]: record.format_order})
    end
  end

  def zoom_line(distance)
    if (distance >= 6000)
      zoom = 2
    elsif (distance >= 200)
      zoom = 4
    elsif (distance < 200 and distance >= 100)
      zoom = 7
    elsif (distance < 100 and distance >= 70)
      zoom = 8
    elsif (distance < 70 and distance >= 50)
      zoom = 9
    elsif (distance < 50 and distance >= 40)
      zoom = 11
    elsif (distance < 40 and distance >= 30)
      zoom = 12
    elsif (distance < 30 and distance >= 20)
      zoom = 13
    elsif (distance < 20 and distance >= 10)
      zoom = 14
    else
      zoom = 15
    end
    return zoom
  end
  
  def zoom_range(distance)
    if (distance >= 200)
      zoom = 4
    elsif (distance < 200 and distance >= 100)
      zoom = 4
    elsif (distance < 100 and distance >= 70)
      zoom = 5
    elsif (distance < 70 and distance >= 50)
      zoom = 6
    elsif (distance < 50 and distance >= 40)
      zoom = 7
    elsif (distance < 40 and distance >= 30)
      zoom = 8
    elsif (distance < 30 and distance >= 20)
      zoom = 9
    elsif (distance < 20 and distance >= 10)
      zoom = 10
    else
      zoom = 17
    end
    return zoom
  end

  def get_all_markers(locations)
    lats = []
    lngs = []
    markers = []
    locations.each do|location|
      if location.lat && location.lng
        lats << location.lat
        lngs << location.lng
        markers << GMarker.new([location.lat, location.lng],:title => LocationsController::TITLE, :info_window => location.full_address)
      end
    end
    return markers, lats, lngs
  end

  def background_url
    if request.env["HTTP_USER_AGENT"].index("iPad") || request.env["HTTP_USER_AGENT"].index("iPod")
      bg_image_path(BG_IPAD)
    else
      bg_image_path(BG_DEFAULT)
    end
  end

  def bg_image_path(image_name)
    image_url = ""
    file_names = ["#{image_name}.jpg", "#{image_name}.png", "#{image_name}.gif"]
    file_names.each do |file_name|
      current_background = File.join("public/system/background_images", file_name)
      if File.exists?(current_background)
        image_url = File.join("/system/background_images", file_name)
      end
    end
    if image_url.blank?
      image_url = File.join("/system/background_images", "background_backup.jpg")
    end
    image_url
  end

end
