class LocationsController < ApplicationController
  TITLE = "Where Am I?"
  ZOOM = 3
  DEFAULT_LOCATION = {
    :center => [37.09024, -95.712891],
    :address => "United States"
  }

  def index
    @map = get_map
  end

  def search
    search = params[:search] || ""
    begin
      unless search.empty?
        @lat_lng = GymLocation.get_lat_lng(search)
        @locations = GymLocation.find_within(1000, :origin => search, :order=>'distance')
      end
    rescue Exception => ex
      puts ex
    end
    render :update do |page|
      page.replace_html "#results", :partial => "locations"
      map = Variable.new("map")
      page << map.clear_overlays
      if @locations && @locations.size > 0
        markers, lats, lngs = get_all_markers(@locations)
        center = [lats.instance_eval { reduce(:+) / size.to_f }, lngs.instance_eval { reduce(:+) / size.to_f }]
        zoom = zoom_range(@locations[0].distance_to(center).to_f)
        page << map.set_center(GLatLng.new(center), zoom)
        markers.each do |marker|
          page << map.add_overlay(marker)
        end
      else
        page << map.set_center(GLatLng.new(DEFAULT_LOCATION[:center]), ZOOM)
      end
    end
  end

  def point_direction
    location = GymLocation.find(params[:id])
    center, address = get_location(location)
    map = Variable.new("map")
    render :update do |page|
      marker = GMarker.new(center,:title => TITLE, :info_window => address)
      page << map.clear_overlays
      page << map.set_center(GLatLng.new(center, ZOOM))
      page << map.add_overlay(marker)
    end
  end

  def line_direction
    location = GymLocation.find(params[:id])
    center1, address1 = get_location(location)
    map = Variable.new("map")
    center2, address2 = params[:center].map{|x| x.to_f}, params[:address]
    center = [(center1[0] + center2[0])/2, (center1[1] + center2[1])/2]
    render :update do |page|
      zoom = zoom_line(params[:distance].to_f)
      page.call "Location.showDistance", center1 << address1, center2 << address2, center, zoom
    end
  end
  private

  def get_map(location = nil)
    center, address = get_location(location)
    map = GMap.new("map_div_id")
    map.control_init(:large_map => true, :map_type => true)
    map.center_zoom_init(center, ZOOM)
    return map
  end

  def get_location(location)
    center = DEFAULT_LOCATION[:center]
    address = DEFAULT_LOCATION[:address]
    if location
      center = [location.lat, location.lng]
      address = location.full_address
    end
    return center, address
  end
end