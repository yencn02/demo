require 'spec_helper'

describe Price do
  fixtures :video_formats

  before(:each) do
    @valid_attributes = {
      :amount_in_cents => 3000,
      :currency => "USD",
      :product_type => "Video",
      :product_id => video_formats(:central_park_download).id
    }
  end

  it "should create a new instance given valid attributes" do
    Price.create!(@valid_attributes)
  end

  it "should create a new instance given valid attributes" do
    price = Price.create!(@valid_attributes)
    price.amount.should == Money.new(3000)
    price.amount.format.should == '$30.00'
  end
end
