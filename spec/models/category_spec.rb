require 'spec_helper'

describe Category do
  before(:each) do
    @valid_attributes = {
      :name => "Cycling"
    }
  end

  it "should create a new instance given valid attributes" do
    Category.create!(@valid_attributes)
  end

  it "should generate a slug based on the title" do
    category = Category.create!(@valid_attributes)
    category.slug.should == category.name.parameterize
  end
end
