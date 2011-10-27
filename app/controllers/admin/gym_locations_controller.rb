class Admin::GymLocationsController < Admin::BaseController
  
  active_scaffold :gym_locations do |config|
    config.columns = [:location_name, :phone, :website, :address1, :address1, :country, :state, :city, :zipcode]

    config.list.columns = [:location_name, :phone, :website, :address1, :address1, :country, :state, :city, :zipcode]
  end
end