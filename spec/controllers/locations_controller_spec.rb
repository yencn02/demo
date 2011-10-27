require 'spec_helper'
include Geokit::Geocoders
describe LocationsController do
  it "#index" do
    locations = mock("List of locations")
    GymLocation.should_receive(:all).and_return locations
    center = [37.09024, -95.712891]
    address = "United States"
    map = mock("map")
    GMap.should_receive(:new).with("map_div_id").and_return map
    map.should_receive(:control_init).with(:large_map => true, :map_type => true)
    map.should_receive(:center_zoom_init).with(center, LocationsController::ZOOM)
    maker = mock("maker")
    GMarker.should_receive(:new).with(center, :title => LocationsController::TITLE, :info_window => address).and_return maker
    map.should_receive(:overlay_init).with(maker)
    get :index
    assigns[:locations].should == locations
    assigns[:map].should == map
  end

  describe "#search" do
    it "unhappy case" do
      search = ""
      locations = mock("List of locations")
      GymLocation.should_receive(:all).and_return locations
      post :search, :search => search
      response.should render_template("locations/_locations")
      assigns[:locations].should == locations
    end

    it "happy case" do
      search = "some thing"
      locations = [mock_model(GymLocation, :geocoder_address => mock("geocoder_address"))]
      rand(5).times do
        locations << mock_model(GymLocation)
      end
      GymLocation.should_receive(:search).with(search).and_return locations
      lat_lng = mock("lat_lng")
      GymLocation.should_receive(:get_lat_lng).with(search).and_return lat_lng
      post :search, :search => search
      response.should render_template("locations/_locations")
      assigns[:locations].should == locations
      assigns[:lat_lng].should == lat_lng
    end
  end

  describe "#point_direction" do
    it "happy case" do
      params_id = "#{rand(10)}"
      location = mock_model(GymLocation, :lat => mock("lat"), :lng => mock("lng"), :full_address => mock("full_address"))
      GymLocation.should_receive(:find).with(params_id).and_return location
      #for get_location method
      center = [location.lat, location.lng]
      address = location.full_address
      #end for get_location method
      map = mock("map")
      Variable.should_receive(:new).with("map").and_return map
      map.should_receive(:clear_overlays)
      glatlng = mock("GLatLng")
      GLatLng.should_receive(:new).with(center, LocationsController::ZOOM).and_return glatlng
      map.should_receive(:set_center).with(glatlng)
      marker = mock("marker")
      GMarker.should_receive(:new).with(center,:title => LocationsController::TITLE, :info_window => address).and_return marker
      map.should_receive(:add_overlay).with(marker)
      get :point_direction, :id => params_id
    end
  end

end