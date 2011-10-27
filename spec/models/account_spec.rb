require 'spec_helper'

describe Account do
  describe "Instance Method" do

    before :each do
      @account = Account.new
    end
    
    describe "#to_label" do
      
      it "should return label" do
        @account.to_label.should == "#{@account.last_name}, #{@account.first_name}"
      end

    end

  end
end
