require 'spec_helper'

describe CartController do
  before :each do
    @cart = mock_model(Cart)
    controller.stub(:load_cart).and_return @cart
  end
  
  describe "#update_items" do
    it "#should update cart info" do
      params_cart = {"1" => "2"}
      params_cart.each do|k, v|
        @cart.should_receive(:add_or_update).with(k.to_i, v.to_i)
      end
      post :update_items, :cart => params_cart
      assigns[:cart].should == @cart
      response.should redirect_to(cart_account_path)
    end
    it "#should update cart info" do
      params_cart = nil
      post :update_items, :cart => params_cart
      response.should redirect_to(cart_account_path)
    end
  end
  describe "#add_item" do
    it "#should update cart info" do
      params_price_id = "1"
      @cart.should_receive(:add_or_update).with(params_price_id)
      get :add_item, :price_id => params_price_id
      response.should redirect_to(cart_account_path)
    end
    it "#should update cart info" do
      params_cart = nil
      post :update_items, :cart => params_cart
      response.should redirect_to(cart_account_path)
    end
  end
  describe "#remove_item" do
    it "#should remove item successfully" do
      params_price_id = "1"
      @cart.should_receive(:remove).with(params_price_id)
      get :remove_item, :price_id => params_price_id
      response.should redirect_to(cart_account_path)
    end
    it "#no params :price_id" do
      params_price_id = nil
      get :remove_item, :price_id => params_price_id
      response.should redirect_to(cart_account_path)
    end
  end

#  describe "#save_for_later" do
#    it "#should upate item status successfully" do
#      params_price_id = "1"
#      @cart.should_receive(:save_for_later).with(params_price_id)
#      get :save_for_later, :price_id => params_price_id
#      response.should redirect_to(cart_account_path)
#    end
#    it "#no params :price_id" do
#      params_price_id = nil
#      get :save_for_later, :price_id => params_price_id
#      response.should redirect_to(cart_account_path)
#    end
#  end

#  describe "#move_to_cart" do
#    it "#should upate item status successfully" do
#      params_price_id = "1"
#      @cart.should_receive(:move_to_cart).with(params_price_id)
#      get :move_to_cart, :price_id => params_price_id
#      response.should redirect_to(saved_items_account_path)
#    end
#    it "#no params :price_id" do
#      params_price_id = nil
#      get :move_to_cart, :price_id => params_price_id
#      response.should redirect_to(saved_items_account_path)
#    end
#  end

  describe "#set_shipping_info" do
    it "set shipping info from an existing address" do
      params_address_id = "1"
      @cart.should_receive(:set_shipping_info).with(params_address_id.to_i)
      get :set_shipping_info, :address_id => params_address_id
      response.should redirect_to(billing_address_account_path)
    end
    it "set shipping info from a new address unsuccessfully" do
      params_address_book = {"some" => {}}
      
      current_user = mock_model(User, :account => mock_model(Account, :id => 1))
      controller.should_receive(:current_user).and_return current_user
      
      address_book = mock_model(AddressBook)
      AddressBook.should_receive(:find_or_new).with(params_address_book, current_user.account.id).and_return address_book

      result = false
      address_book.should_receive(:save).and_return result

      post :set_shipping_info, :address_book => params_address_book
      response.should have_rjs(:show, "#message-wraper")
      response.should have_rjs(:replace_html, "#message-wraper")
    end
    it "set shipping info from a new address successfully" do
      params_address_book = {"some" => {}}

      current_user = mock_model(User, :account => mock_model(Account, :id => 1))
      controller.should_receive(:current_user).and_return current_user

      address_book = mock_model(AddressBook, :id => 1)
      AddressBook.should_receive(:find_or_new).with(params_address_book, current_user.account.id).and_return address_book

      result = true
      address_book.should_receive(:save).and_return result
      @cart.should_receive(:set_shipping_info).with(address_book.id)

      post :set_shipping_info, :address_book => params_address_book
      response.body.should == "window.location.href = \"/account/billing_address\";"
    end
  end

  describe "#set_billing_info" do
    describe "should render error messages" do
      before :each do
        @params_date = {"some" => "thing"}
        @params_credit_card = {"first_name" => "Test2", "last_name" => "Test1"}
        @params_address_book = {"some2" => "thing2"}
        @params_address_book["last_name"] = @params_credit_card["last_name"]
        @params_address_book["first_name"] = @params_credit_card["first_name"]

        @params_credit_card.merge!(@params_date)
        current_user = mock_model(User, :account => mock_model(Account, :id => 1))
        controller.should_receive(:current_user).and_return current_user

        @credit_card = mock_model(CreditCard)
        CreditCard.should_receive(:find_or_new).with(@params_credit_card).and_return @credit_card

        @address_book = mock_model(AddressBook)
        AddressBook.should_receive(:find_or_new).with(@params_address_book, current_user.account.id).and_return @address_book
      end

      after :each do
        post :set_billing_info, :credit_card => @params_credit_card, :address_book => @params_address_book, :date => @params_date
        response.should have_rjs(:show, "#message-wraper")
        response.should have_rjs(:replace_html, "#message-wraper")
      end

      it "for credit card" do
        save_billing_info(@cart, @credit_card, @address_book, 2)
      end

      it "for address book" do
        save_billing_info(@cart, @credit_card, @address_book, 3)
      end
    end
    
    it "should redirect to confirm_order_account_path" do
      params_date = {"some" => "thing"}
      params_credit_card = {"first_name" => "Test2", "last_name" => "Test1"}
      params_address_book = {"some2" => "thing2"}
      params_address_book["last_name"] = params_credit_card["last_name"]
      params_address_book["first_name"] = params_credit_card["first_name"]

      params_credit_card.merge!(params_date)
      
      current_user = mock_model(User, :account => mock_model(Account, :id => 1))
      controller.should_receive(:current_user).and_return current_user

      credit_card = mock_model(CreditCard)
      CreditCard.should_receive(:find_or_new).with(params_credit_card).and_return credit_card

      address_book = mock_model(AddressBook)
      AddressBook.should_receive(:find_or_new).with(params_address_book, current_user.account.id).and_return address_book

      error_object = save_billing_info(@cart, credit_card, address_book, 1)

      post :set_billing_info, :credit_card => params_credit_card, :address_book => params_address_book, :date => params_date

      response.body.should == "window.location.href = \"/account/confirm_order\";"
    end    
  end

  describe "#checkout" do

    it "should render update" do
      @cart.should_receive(:check_balance).and_return false
      get :checkout
      response.should have_rjs(:show, "#app-message")
      response.should have_rjs(:replace_html, "#app-message .bad")
      response.should have_rjs(:show, "#app-message .bad")
    end

    it "should redirect" do
      @cart.should_receive(:check_balance).and_return true
      @cart.should_receive(:process_to_checkout)
      get :checkout
      response.body.should == "window.location.href = \"/account/cart\";"
    end
    
  end
  
  def save_billing_info(cart, credit_card, address_book, case_)
    case case_
    when 1
      credit_card.should_receive(:save).and_return true
      address_book.should_receive(:save).and_return true
      cart.should_receive(:set_billing_info).with(address_book.id, credit_card.id)
      return nil
    when 2
      credit_card.should_receive(:save).and_return false
      return credit_card
    when 3
      credit_card.should_receive(:save).and_return true
      address_book.should_receive(:save).and_return false
      return address_book
    end
  end
end
