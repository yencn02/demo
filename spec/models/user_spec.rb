require 'spec_helper'

describe User do

  describe "Instance Methods" do

    before :each do
      @user = User.new
    end

    describe "#to_label" do
      it "should to_label" do
        @user.stub(:id).and_return mock("ID")
        @user.to_label.should == "User (#{@user.id})"
      end
    end


    describe "#is_admin(user)" do
      it "should return boolean" do
        user_session = mock("user_session")
        email = mock("email")
        user_session.stub(:email).and_return email
        user = mock("user")
        User.stub(:find_by_email).with(email).and_return user
        result = mock("result")
        user.stub(:is_admin).and_return result
        User.is_admin(user_session).should == result
      end
    end
  end
  
end
