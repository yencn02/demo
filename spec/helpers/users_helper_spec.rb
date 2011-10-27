require 'spec_helper'

describe UsersHelper do
  it "#address_to_js" do
    address = mock_model(AddressBook)
    address.stub(:to_json)
    helper.address_to_js(address).should == javascript_tag("var billing_address = #{address.to_json}")
  end

  it "#address_books_to_js" do
    address_books = mock("AddressBooks")
    address_books.stub(:to_json)
    helper.address_books_to_js(address_books).should == javascript_tag("var addressBooks = #{address_books.to_json}")
  end

end
