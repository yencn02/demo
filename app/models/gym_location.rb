class GymLocation < ActiveRecord::Base
  COUNTRY_REQUIRED_STATES = Carmen::STATES.map{|x| x[0]}
  validates_presence_of :location_name, :phone, :address1, :country, :city, :zipcode
  validates_presence_of :state, :if => Proc.new { |location| COUNTRY_REQUIRED_STATES.index(location.country) }
  validates_format_of :zipcode,
                      :with => /^\d{5}((-)?\d{4})?|([A-Za-z]\d[A-Za-z]([- ])?\d[A-Za-z]\d)/,
                      :message => "correct format For US 5 digits like 85123, for Canada a format like R2G 1T9"
  validates_format_of_zipcode :zipcode
  validates_format_of_url :website, :if => Proc.new { |location| location.website && !location.website.empty? }

  acts_as_mappable :default_units => :miles
  before_validation_on_create :set_geocoder_address

  def to_label
    "Location ##{id}"
  end
  def set_geocoder_address
    geo=Geokit::Geocoders::MultiGeocoder.geocode(geocoder_address)
    errors.add(:address, "Could not Geocode address") if !geo.success
    self.lat, self.lng = geo.lat,geo.lng if geo.success
  end

  def full_address
    "#{location_name}, #{address1}, #{city}, #{state} #{zipcode}, #{country}"
  end

  def geocoder_address
    columns = ["city"]
    columns.delete_if{|column| !self[column]}
    values = columns.map{|column| self[column]}
    values.join(", ")
  end

  class << self
    def get_lat_lng(address)
      geo=Geokit::Geocoders::MultiGeocoder.geocode(address)
      if geo.success
        return [geo.lat, geo.lng]
      else
        return nil
      end
    end
  end
end
