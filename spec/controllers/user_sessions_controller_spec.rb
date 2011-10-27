require 'spec_helper'

describe UserSessionsController do
  describe "#new" do
    it "should redirect to account page" do
      controller.stub(:current_user).and_return mock("user")
      get :new
      response.should redirect_to information_account_url
    end
    it "should render template :new" do
      controller.stub(:current_user).and_return nil
      user_session = mock_model(UserSession)
      UserSession.should_receive(:new).and_return user_session
      get :new
      response.should render_template(:new)
      assigns[:user_session].should == user_session
    end
  end

  describe "#create" do

    it "should redirect to informatn account page" do
      controller.stub(:current_user).and_return mock("user")
      post :create
      response.should redirect_to information_account_url
    end

    it "should render template :new" do
      params_user_session = {"some" => "thing"}
      controller.stub(:current_user).and_return nil

      user_session = mock("user session")
      UserSession.should_receive(:new).with(params_user_session).and_return user_session
      user_session.should_receive(:save).and_return nil

      post :create, :user_session => params_user_session
      
      response.should render_template(:new)
      assigns[:user_session].should == user_session
    end

    describe "should login successfully" do
      before :each do
        @params_user_session = {"some" => "thing"}
        controller.stub(:current_user).and_return nil

        user_session = mock("user session")
        UserSession.should_receive(:new).with(@params_user_session).and_return user_session
        user_session.should_receive(:save).and_return mock("successful")
        User.should_receive(:is_admin).with(user_session).and_return false

        session[:return_to] = nil
      end

      after :each do
        controller.should_receive(:redirect_back_or_default).with(information_account_url)
        post :create, :user_session => @params_user_session
      end
      
      it "with no shopping cart" do
        update_account_cart(1)
      end
      
      it "items in cart" do
        update_account_cart(2)
      end
    end

    it "should redirect to admin user" do
      params_user_session = {"some" => "thing"}
      controller.stub(:current_user).and_return nil

      user_session = mock("user session")
      UserSession.should_receive(:new).with(params_user_session).and_return user_session
      user_session.should_receive(:save).and_return mock("successful")
      User.should_receive(:is_admin).with(user_session).and_return mock("true")

      session[:return_to] = nil
      controller.should_receive(:redirect_back_or_default).with(admin_users_path)
      post :create, :user_session => params_user_session
    end

  end

  describe "#destroy" do
    it "should logout successfully" do
      current_user_session = mock("current user session")
      current_user = mock("current user")
      controller.should_receive(:current_user_session).and_return current_user_session
      controller.should_receive(:current_user).and_return current_user

      current_user_session.should_receive(:destroy)
      controller.should_receive(:redirect_back_or_default).with(login_url)
      delete :destroy
    end
  end

  def update_account_cart(case_)
    session[:session_id] = mock("session[:session_id]")
    case case_
    when 1
      Cart.should_receive(:session_cart).with(session[:session_id]).and_return nil
    when 2
      cart = mock_model(Cart)
      Cart.should_receive(:session_cart).with(session[:session_id]).and_return cart
      account = mock_model(Account)
      session["user_credentials_id"] = mock("session[user_credentials_id]")
      Account.should_receive(:find_by_user_id).with(session["user_credentials_id"]).and_return account
      cart.should_receive(:to_account_cart).with(account)
    end
  end
end
