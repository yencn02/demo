require 'spec_helper'

describe GymLocation do
  describe "Instance Methods" do

    before :each do
      @location = GymLocation.new
    end
    
    describe "#full_address" do
      it "should return full address" do
        @location.stub(:location_name).and_return mock("location name")
        @location.stub(:address1).and_return mock("address1")
        @location.stub(:city).and_return mock("city")
        @location.stub(:state).and_return mock("state")
        @location.stub(:zipcode).and_return mock("zipcode")
        @location.stub(:country).and_return mock("country")
        address = "#{@location.location_name}, #{@location.address1}, #{@location.city}, #{@location.state} #{@location.zipcode}, #{@location.country}"
        @location.full_address.should == address
      end
    end

    describe "#geocoder_address" do
      it "should return geocoder_address" do
        columns = ["city", "state", "zipcode", "country"]
        nil_field = columns[rand(4)]
        columns.each do |column|
          value = mock(column)
          value = nil if column == nil_field
          @location[column] = value
        end
        columns.delete_if{|column| !@location[column]}
        values = columns.map{|column| @location[column]}
        @location.geocoder_address.should == values.join(", ")
      end
    end
    
  end

  describe "Class Methods" do
    describe "#search" do
      it "should search with single token with carmen state code" do
        query = "Lebanon Yukon White"
        tokens = query.to_s.gsub(/\W/, " ").gsub(/  /, " ").split(" ")
        tokens << query
        tokens.each do |token|
          code = Carmen::state_code(token)
          tokens << code if code
        end
        expected_results = mock("expected_results")
        GymLocation.should_receive(:city_or_state_or_zipcode_like_any).with(tokens).and_return expected_results
        GymLocation.search(query).should == expected_results
      end
      
    end
  end

end