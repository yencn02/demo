require 'spec_helper'

describe Admin::BaseController do

  describe "#dashboard" do
    it "should require to login" do
      get :dashboard
      response.should redirect_to login_url
    end
    it "happy case: login successfully" do
      controller.should_receive(:current_user_admin).and_return mock("current_user_admin")
      get :dashboard
      response.should render_template("dashboard")
    end
  end
  
end
