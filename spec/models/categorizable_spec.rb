require 'spec_helper'

describe Categorizable do
  fixtures :categories, :videos

  before(:each) do
    @valid_attributes = {
      :category_id => categories(:cycling).id,
      :categorized_type => "Video",
      :categorized_id => videos(:central_park).id
    }
  end

  it "should create a new instance given valid attributes" do
    Categorizable.create!(@valid_attributes)
  end

  it "should support polymorphic categorizations" do
    category = Categorizable.create!(@valid_attributes)
    category.categorized.should == videos(:central_park)
  end
end
