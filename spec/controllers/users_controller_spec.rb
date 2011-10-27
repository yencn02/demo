require 'spec_helper'

describe UsersController do
  def load_cart(case_)
    case case_
    when 1
      controller.stub(:current_user).and_return nil
      @cart = mock_model(Cart)
      Cart.should_receive(:get_cart).with(Cart::SESSION_TYPE, session[:session_id]).and_return @cart
    when 2
      current_user = mock_model(User, :account => mock_model(Account, :id => rand(10)))
      controller.stub(:current_user).and_return current_user
      @cart = mock_model(Cart)
      Cart.should_receive(:get_cart).with(Cart::ACCOUNT_TYPE, current_user.account.id).and_return @cart
    end
  end

  describe "#cart" do
    before :each do
      Cart.should_receive(:destroy_expired_carts)
    end

    after :each do
      line_items = mock("Line items")
      @cart.should_receive(:line_items).and_return line_items
      line_items.should_receive(:paginate).with(:page => nil, :per_page => 5).and_return line_items
      get :cart
      assigns[:cart].should == @cart
      response.should render_template(:cart)
    end
    
    it "should load session cart" do
      load_cart(1)
    end

    it "should load account cart" do
      load_cart(2)
    end
  end

  #  describe "#saved_items" do
  #    it "should call load_cart" do
  #      cart = mock_model(Cart)
  #      controller.should_receive(:load_cart).and_return cart
  #      get :saved_items
  #      assigns[:cart].should == cart
  #      response.should render_template(:saved_items)
  #    end
  #  end
  describe "#shipping_address" do
    it "# not login" do
      current_user = nil
      controller.should_receive(:current_user).and_return current_user
      get :shipping_address
      response.should redirect_to new_session_path
      session[:return_to].should == shipping_address_account_path
    end
    it "# logged in" do
      address_books = mock("address books")
      current_user = mock_model(User, :account => mock_model(Account, :address_books => address_books))
      controller.stub(:current_user).and_return current_user

      cart = mock_model(Cart)
      cart.stub(:empty?).and_return false

      controller.should_receive(:load_cart).and_return cart
      
      address_book = mock_model(AddressBook)
      AddressBook.should_receive(:new).and_return address_book
      get :shipping_address
      assigns(:address_books).should == current_user.account.address_books
      assigns(:address_book).should == address_book
      assigns(:cart).should == cart
    end

    it "# logged in cart empty" do
      address_books = mock("address books")
      current_user = mock_model(User, :account => mock_model(Account, :address_books => address_books))
      controller.stub(:current_user).and_return current_user

      cart = mock_model(Cart)
      controller.should_receive(:load_cart).and_return cart
      cart.stub(:empty?).and_return true
      get :shipping_address
      response.should redirect_to cart_account_path
    end
  end

  describe "#billing_address" do
    it "# not login" do
      current_user = nil
      controller.should_receive(:current_user).and_return current_user
      get :billing_address
      response.should redirect_to new_session_path
      session[:return_to].should == billing_address_account_path
    end
    
    describe "# login" do
      before :each do
        current_user = mock_model(User, :account => mock_model(Account))
        controller.should_receive(:current_user).and_return current_user
      end
      
      describe "# happy case" do
        before :each do
          @cart = mock_model(Cart)
          controller.should_receive(:load_cart).and_return @cart

          @shipping_address = mock("shipping address")
          @cart.should_receive(:shipping_address).twice.and_return @shipping_address

          @card_types = mock("List of card types")
          CardType.should_receive(:all).and_return @card_types
        end

        after :each do
          assigns(:card_types).should == @card_types
          assigns(:credit_card).should == @credit_card
          assigns(:address_book).should == @address_book
          assigns(:shipping_address).should == @shipping_address
          assigns(:cart).should == @cart
        end

        it "#with existing billing info" do
          @address_book = mock_model(AddressBook)
          @cart.should_receive(:billing_address).twice.and_return @address_book

          @address_book.should_receive(:clone).and_return @address_book

          @credit_card = mock_model(CreditCard)
          @cart.should_receive(:credit_card).and_return @credit_card

          get :billing_address
        end

        it "#with empty billing info" do
          @cart.should_receive(:billing_address).once.and_return nil
          @address_book = mock_model(AddressBook)
          AddressBook.should_receive(:new).and_return @address_book

          @cart.should_receive(:credit_card).and_return nil
          @credit_card = mock_model(CreditCard)
          CreditCard.should_receive(:new).and_return @credit_card

          get :billing_address
        end
      end

      it "# unhappy case" do
        cart = mock_model(Cart)
        controller.should_receive(:load_cart).and_return cart
        cart.should_receive(:shipping_address).and_return nil
        get :billing_address
        response.should redirect_to shipping_address_account_path
      end

    end
  end

  describe "#remove_address" do
    it "should do nothing" do
      current_user = mock_model(User, :account => mock_model(Account))
      controller.should_receive(:current_user).and_return current_user
      params_address_id = nil
      AddressBook.should_not_receive(:find)
      get :remove_address, :address_id => params_address_id
      response.should redirect_to :action => :shipping_address
    end
    it "should remove an existing address" do
      current_user = mock_model(User, :account => mock_model(Account))
      controller.should_receive(:current_user).and_return current_user
      params_address_id = "1"
      address = mock_model(AddressBook)
      AddressBook.should_receive(:find).with(params_address_id).and_return address
      address.should_receive(:destroy)
      get :remove_address, :address_id => params_address_id
      response.should redirect_to :action => :shipping_address
    end
  end

  describe "#confirm_order" do
    it "# not login" do
      current_user = nil
      controller.should_receive(:current_user).and_return current_user
      get :confirm_order
      response.should redirect_to new_session_path
      session[:return_to].should == confirm_order_account_path
    end

    describe "# login" do
      before :each do
        current_user = mock_model(User, :account => mock_model(Account))
        controller.should_receive(:current_user).and_return current_user

        @cart = mock_model(Cart)
        controller.should_receive(:load_cart).and_return @cart
      end

      it "should call load_cart" do
        @cart.should_receive(:shipping_address).and_return mock("shipping address")
        @cart.should_receive(:billing_address).and_return mock("billing address")
        @cart.should_receive(:credit_card).and_return mock("billing address")

        line_items = mock("Line items")
        @cart.should_receive(:line_items).and_return line_items
        line_items.should_receive(:paginate).with(:page => nil, :per_page => 5).and_return line_items

        get :confirm_order
        assigns[:cart].should == @cart
        response.should render_template(:confirm_order)
      end

      it "should redirect to shipping address page" do
        @cart.should_receive(:shipping_address).and_return nil
        get :confirm_order
        response.should redirect_to shipping_address_account_path
      end

      it "should redirect to billing address page" do
        @cart.should_receive(:shipping_address).and_return mock("shipping address")
        @cart.should_receive(:billing_address).and_return nil
        get :confirm_order
        response.should redirect_to billing_address_account_path
      end
    end
  end

  describe "#new_user" do
    it "#new user" do
      user = User.new
      user.account = Account.new
      get :new
    end
  end

  describe "#create_user" do
    it "#should be redirect to information account url" do
      params_user = {"some" => "thing"}
      user = mock("User")
      User.should_receive(:new).with(params_user).and_return user
      
      user.should_receive(:account).and_return mock("nil")
      Account.stub(:create).and_return mock("account")
      user.should_receive(:save).and_return true
      post :create, :user => params_user
      response.should redirect_to information_account_url
    end

    it "#should be render new" do
      params_user = {"some" => "thing"}
      user = mock("User")
      User.should_receive(:new).with(params_user).and_return user

      user.should_receive(:account).and_return mock("nil")
      Account.stub(:create).and_return mock("account")
      user.should_receive(:save).and_return false
      post :create, :user => params_user
      response.should render_template(:new)
    end
  end

  describe "#show" do
    it "should be render show" do
      current_user = mock_model(User, :account => mock_model(Account))
      controller.should_receive(:current_user).and_return current_user
      get :show
      response.should redirect_to information_account_url
    end
  end
  
  describe "information" do
    it "should be render information" do      
      current_user = mock_model(User, :account => mock_model(Account))
      controller.should_receive(:current_user).and_return current_user
      cart = mock_model(Cart)
      controller.stub(:load_cart).and_return cart
      get :information
      response.should render_template(:information)
    end
  end


  describe "update_user" do
    it "#should be render template infomation - update successfully" do
      params_user = mock("params_user")
      current_user = mock_model(User, :account => mock_model(Account))
      controller.should_receive(:current_user).twice.and_return current_user
      current_user.should_receive(:update_attributes).with(params_user).and_return true
      put :update, :user => params_user
      response.should render_template(:information)
    end

    it "#should be render template infomation - update fail" do
      params_user = mock("params_user")
      current_user = mock_model(User, :account => mock_model(Account))
      controller.should_receive(:current_user).twice.and_return current_user
      current_user.should_receive(:update_attributes).with(params_user).and_return false
      put :update, :user => params_user
      response.should render_template(:information)
    end
  end
end
