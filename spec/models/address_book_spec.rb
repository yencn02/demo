require 'spec_helper'

describe AddressBook do
  
  describe "Instance Methods" do

    before :each do
      @address = AddressBook.new
    end

    describe "#to_order" do
      it "should clone to a new address book" do
        address = mock_model(AddressBook)
        @address.should_receive(:clone).and_return address
        address.should_receive(:in_use=).with(true)
        address.should_receive(:save)
        @address.to_order.should == address
      end
    end

    describe "#to_hash" do
      it "to hash"  do
        hash = {
          "FirstName" => @address.first_name,
          "LastName" => @address.last_name,
          "OrderShippingAddress" => {
            "Address" => @address.address1,
            "Address2" => @address.address2,
            "City" => @address.city,
            "StateCode" => @address.state,
            "CountryCode" => @address.country,
            "StateName" => Carmen::state_name(@address.state) ,
            "CountryName" => Carmen::country_name(@address.country),
            "PostalCode" => @address.zipcode
          },
          "Phone" => @address.phone,
          "ProductShippingTypeID" => @address.shipping_type_id
        }
        @address.to_hash.should == hash
      end
    end
  end

  

  describe "Class Methods" do
    describe "#find_or_new" do

      it "return an existing address" do
        args = {:some => {}}
        account_id = 1

        args[:account_id] = account_id
      
        address = mock_model(AddressBook)
        AddressBook.should_receive(:find).with(:first, :conditions => args).and_return address
        AddressBook.find_or_new(args, account_id).should == address
      end

      it "return an new address" do
        args = {:some => {}}
        account_id = 1

        args[:account_id] = account_id

        AddressBook.should_receive(:find).with(:first, :conditions => args).and_return nil

        address = mock_model(AddressBook)
        AddressBook.should_receive(:new).with(args).and_return address
        AddressBook.find_or_new(args, account_id).should == address
      end

      it "should update an existing address" do
        args = {:some => {}, "id" => "#{rand(10)}"}
        args[:in_use] = false
        account_id = 1
      
        id = args["id"]
        args_new = args.clone
        args_new.delete_if{|k,v| k == "id"}

        address = mock_model(AddressBook)
        AddressBook.should_receive(:find).with(id).and_return address
      
        address.should_receive(:update_attributes).with(args_new)

        AddressBook.find_or_new(args, account_id).should == address
      end
    end

  end# End Class Method
  
end
