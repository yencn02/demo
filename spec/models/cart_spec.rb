require 'spec_helper'

describe Cart do
  describe "Instance Methods" do
    before :each do
      @cart = Cart.new
    end
    describe "#empty?" do
      it "should be false" do
        line_items = [mock_model(LineItem)]
        @cart.stub(:line_items).and_return line_items
        @cart.empty?.should be_false
      end
      it "should be true" do
        line_items = []
        @cart.stub(:line_items).and_return line_items
        @cart.empty?.should be_true
      end
    end

    describe "#find_item" do
      it "found result" do
        price_id = 1
        line_items = mock("List of items")
        line_item = mock_model(LineItem)
        line_items.stub(:first).with({:conditions => {:price_id => price_id } }).and_return line_item
        @cart.stub(:line_items).and_return line_items
        @cart.find_item(price_id).should == line_item
      end
      it "no results were found" do
        price_id = 1
        line_items = mock("List of items")
        line_items.stub(:first).with({:conditions => {:price_id => price_id } }).and_return nil
        @cart.stub(:line_items).and_return line_items
        @cart.find_item(price_id).should == nil
      end
    end

    describe "#add_or_update" do
      it "Should update quantity of existing line item" do
        price_id = 1
        quantity = 3
        line_item = mock_model(LineItem)

        @cart.stub(:find_item).with(price_id).and_return line_item
        line_item.stub(:[]=).with(:quantity, quantity)
        line_item.stub(:save).and_return true
        @cart.add_or_update(price_id, quantity).should be_true
      end
      it "Should add a new line item" do
        price_id = 1
        quantity = 3
        @cart.stub(:find_item).with(price_id).and_return nil
        line_item = mock_model(LineItem, :price => mock_model(Price, :product => mock("product"), :amount_in_cents => mock("amount_in_cents")))
        LineItem.should_receive(:new).with(:cart_id => @cart.id, :price_id => price_id, :quantity => quantity).and_return line_item
        line_item.stub(:product=).with(line_item.price.product)
        line_item.stub(:unit_price_in_cents=).with(line_item.price.amount_in_cents)
        line_item.stub(:save).and_return true
        @cart.add_or_update(price_id, quantity).should be_true
      end
    end
    describe "#total_in_cents" do
      it "should return the total cost of all items" do
        total = 0
        line_items = Array.new
        (rand(100)+1).times do
          subtotal = rand(100)
          line_item = mock_model(LineItem)
          line_item.stub(:subtotal_in_cents).and_return(subtotal)
          line_items << line_item

          total += subtotal
        end
      
        @cart.stub(:line_items).and_return(line_items)

        @cart.total_in_cents.should == total
      end
    end

    describe "#total_items" do
      it "should return the total items" do
        total = 0
        line_items = Array.new
        (rand(100) + 1).times do
          total_items = rand(100)
          line_item = mock_model(LineItem)
          line_item.stub(:quantity).and_return(total_items)
          line_items << line_item

          total += total_items
        end

        @cart.stub(:line_items).and_return(line_items)

        @cart.total_items.should == total
      end
    end
    
    describe "#total" do
      it "should return format as money" do
        @cart.stub(:total_in_cents).and_return(rand(100))
        @cart.total.should == Money.new(@cart.total_in_cents)
      end
    end
    describe "#remove" do
      it "should do nothing" do
        price_id = 1
        line_item = nil
        @cart.stub(:find_item).with(price_id).and_return line_item
        @cart.remove(price_id).should be_nil
      end
      it "should remove the line item that match id = 1" do
        price_id = 1
     
        line_item = mock_model(LineItem)
        result = mock("something")
        line_item.stub(:destroy).and_return result

        @cart.stub(:find_item).with(price_id).and_return line_item

        @cart.remove(price_id).should == result
      end
    end
    describe "#save_for_later" do
      it "should do nothing" do
        price_id = 1
        line_item = nil
        @cart.stub(:find_item).with(price_id).and_return line_item
        @cart.save_for_later(price_id).should be_nil
      end
      it "should remove the line item that match id = 1" do
        price_id = 1

        line_item = mock_model(LineItem)
        result = mock("something")
        line_item.stub(:billing_later=).with(true)
        line_item.stub(:save).and_return result
        @cart.stub(:find_item).with(price_id).and_return line_item
        @cart.save_for_later(price_id).should == result
      end
    end
    describe "#move_to_cart" do
      it "should do nothing" do
        price_id = 1
        saved_items = mock("List of saved items in cart")
        @cart.stub(:saved_items).and_return saved_items
        saved_items.stub(:first).with({:conditions => {:price_id => price_id}}).and_return nil
        @cart.move_to_cart(price_id).should be_nil
      end
      it "should remove the line item that match id = 1" do
        price_id = 1
        line_item = mock_model(LineItem)
        saved_items = mock("List of saved items in cart")
        @cart.stub(:saved_items).and_return saved_items
        saved_items.stub(:first).with({:conditions => {:price_id => price_id}}).and_return line_item
        line_item.stub(:billing_later=).with(false)
        result = mock("something")
        line_item.stub(:save).and_return result
        @cart.move_to_cart(price_id).should == result
      end
    end

    describe "#set_shipping_info" do
      it "should update shipping_address_id" do
        address_id = 1
        @cart.should_receive(:shipping_address_id=).with(address_id).and_return @cart
        result = mock("result")
        @cart.should_receive(:save).and_return result
        @cart.set_shipping_info(address_id).should == result
      end
    end

    describe "#set_billing_info" do
      it "should update billing_address_id and credit_card_id" do
        address_id = 1
        card_id = 2
        @cart.should_receive(:billing_address_id=).with(address_id).and_return @cart
        @cart.should_receive(:credit_card_id=).with(card_id).and_return @cart
        result = mock("result") 
        @cart.should_receive(:save).and_return result
        @cart.set_billing_info(address_id, card_id).should == result
      end
    end
    describe "check_balance and capture" do
      before :each do
        @gateway = mock("Gateway")
        ActiveMerchant::Billing::AuthorizeNetGateway.stub(:new).with(:login => LOGIN_ID, :password=> TRANSACTION_KEY).and_return @gateway
        @cart.stub(:total_in_cents).and_return rand(100)
        credit_card = mock_model(CreditCard, :first_name =>"Test",:last_name =>"Test",
          :expiration_month => 1,:expiration_year => Time.now.year+1, :card_number => "4242424242424242")
        cart_type = mock_model(CardType, :code => "visa")
        credit_card.stub(:card_type).and_return cart_type
        @cart.stub(:credit_card).and_return credit_card
        @cart.stub(:shipping_address).and_return mock_model(AddressBook)
        @cart.stub(:billing_address).and_return mock_model(AddressBook)
        @create_cart_authorize = mock("creditcart")
        ActiveMerchant::Billing::CreditCard.stub(:new).with(
          :first_name => @cart.credit_card.first_name,
          :last_name  => @cart.credit_card.last_name,
          :month      => @cart.credit_card.expiration_month,
          :year       => @cart.credit_card.expiration_year,
          :type       => @cart.credit_card.card_type.code,
          :number     => @cart.credit_card.card_number
        ).and_return @create_cart_authorize
        @options = {:address => {}, :shipping_address => @cart.shipping_address, :billing_address => @cart.billing_address}
      end
      it "#check balance"do
        response = mock("Respone")
        @gateway.stub(:authorize).with(@cart.total_in_cents, @create_cart_authorize, @options).and_return response
        success = mock("success")
        response.stub(:success?).and_return success
        @cart.check_balance.should == success
      end

      it "#capture" do
        response = mock("Respone")
        @gateway.stub(:capture).with(@cart.total_in_cents, @create_cart_authorize, @options).and_return response
        @cart.capture.should == response
      end
    end

    describe "#reset" do
      it "should reset to empty cart" do
        save_billing_info = false
        @cart.should_receive(:billing_address_id=).with(nil)
        @cart.should_receive(:credit_card_id=).with(nil)
        @cart.should_receive(:shipping_address_id=).with(nil)
        @cart.should_receive(:line_items=).with([])
        result = mock("result")
        @cart.should_receive(:save).and_return result
        @cart.reset(save_billing_info).should == result
      end

      it "should reset to empty cart" do
        save_billing_info = true
        @cart.should_not_receive(:billing_address_id=).with(nil)
        @cart.should_receive(:credit_card_id=).with(nil)
        @cart.should_receive(:shipping_address_id=).with(nil)
        @cart.should_receive(:line_items=).with([])
        result = mock("result")
        @cart.should_receive(:save).and_return result
        @cart.reset(save_billing_info).should == result
      end
    end

    describe "#to_order" do
      it "#should move session cart to account cart" do
        save_billing_info = mock("True or False")
        Order.should_receive(:create_order).with(@cart)
        @cart.should_receive(:reset).with(save_billing_info)
        @cart.to_order(save_billing_info)
      end
    end

    describe "#merge_items" do
      before :each do
        @line_items = []
        (rand(10) + 2).times do
          @line_items << mock_model(LineItem,
            :price => mock_model(Price, :id => rand(10)),
            :quantity => rand(100))
        end
      end
      it "with no duplicate items" do
        @line_items.each do |item|
          @cart.should_receive(:find_item).with(item.price.id).and_return nil
          @cart.should_receive(:add_or_update).with(item.price.id, item.quantity)
        end
        @cart.merge_items(@line_items)
      end

      it "with some duplicate items" do
        @line_items.each do |item|
          line_item = mock_model(LineItem, :quantity => rand(100))
          @cart.should_receive(:find_item).with(item.price.id).and_return line_item
          @cart.should_receive(:add_or_update).with(item.price.id, item.quantity + line_item.quantity)
        end
        @cart.merge_items(@line_items)
      end
    end

    describe "#to_account_cart" do
      it "account already have a cart" do
        account = mock_model(Account, :cart => mock_model(Cart))
        account.cart.should_receive(:merge_items).with(@cart.line_items)
        @cart.should_receive(:destroy)
        @cart.to_account_cart(account)
      end

      it "account with no cart" do
        account = mock_model(Account, :cart => nil, :id => rand(100))
        @cart.should_receive(:session_id=).with(nil)
        @cart.should_receive(:account_id=).with(account.id)
        @cart.should_receive(:cart_type=).with(Cart::ACCOUNT_TYPE)
        @cart.should_receive(:save)
        @cart.to_account_cart(account)
      end
    end

    describe "#inuse_addresses" do
      it "should return empty" do
        @cart.billing_address_id = nil
        @cart.shipping_address_id = nil
        @cart.inuse_addresses.should be_empty
      end

      it "should contain billing address" do
        @cart.billing_address_id = rand(100)
        @cart.shipping_address_id = nil
        @cart.inuse_addresses.should == [@cart.billing_address_id]
      end

      it "should contain shipping address" do
        @cart.billing_address_id = nil
        @cart.shipping_address_id = rand(100)
        @cart.inuse_addresses.should == [@cart.shipping_address_id]
      end

      it "should contain both shipping address and billing address" do
        @cart.billing_address_id = rand(100)
        @cart.shipping_address_id = rand(100)
        @cart.inuse_addresses.should == [@cart.billing_address_id,@cart.shipping_address_id]
      end
    end

    describe "#remove_oldest_address" do
      it "should do nothing" do
        num_of_addresses = rand(100) + AddressBook::ADDRESSES_PER_ACCOUNT + 3
        inuse = [rand(num_of_addresses), rand(num_of_addresses)]
        @cart.stub(:inuse_addresses).and_return inuse
        @cart.stub(:account_id).and_return rand(100)
        addresses = []
        for i in 0..num_of_addresses
          addresses << mock_model(AddressBook, :id => rand(5), :destroy => true)
        end
        AddressBook.should_receive(:find).with(:all,
          :conditions => {:in_use => false, :account_id => @cart.account_id}, :order => "updated_at").and_return addresses
        
        addresses.delete_if{|x| inuse.index(x.id)}
        num_of_deleted_items =  num_of_addresses - AddressBook::ADDRESSES_PER_ACCOUNT
        for i in 0..num_of_deleted_items
          addresses[i].destroy if addresses[i]
        end
        @cart.remove_oldest_address
      end
    end

    it "#process to checkout" do
      @cart.should_receive(:capture)
      @cart.stub(:account).and_return mock_model(Account, :user => mock("user"))
      order = mock_model(Order)
      @cart.should_receive(:to_order).and_return order
      order.should_receive(:send_acutrack_request)
      Mailer.should_receive(:deliver_notify_order_number).with(@cart.account.user, order)
      @cart.process_to_checkout
    end
  end

  describe "Class Methods" do
    describe "#get_session_cart" do
      before :each do
        @session_id = "xxxxx"
      end
      it "should return an existing session cart" do
        @cart = mock_model(Cart)
        Cart.should_receive(:find_by_session_id).with(@session_id).and_return @cart
      end
      it "should create a new session cart" do
        @cart = nil
        Cart.should_receive(:find_by_session_id).with(@session_id).and_return @cart
        Cart.should_receive(:create).with(:session_id => @session_id, :cart_type => Cart::SESSION_TYPE)
      end
      after :each do
        Cart.get_session_cart(@session_id).should == @cart
      end
    end

    describe "#get_account_cart" do
      before :each do
        @account_id = 1
        @account = mock_model(Account, :account_id => @account_id)
        Account.stub(:find).with(@account_id).and_return @account
      end
      it "should return an existing account cart" do
        @cart = mock_model(Cart)
        @account.stub(:cart).and_return @cart
      end
      it "should create a new account cart" do
        @cart = nil
        @account.stub(:cart).and_return @cart
        Cart.should_receive(:create).with(:account_id => @account.id)
      end
      after :each do
        Cart.get_account_cart(@account_id).should == @cart
      end
    end

    describe "#get_cart" do
      it "should get session cart"do
        type = Cart::ACCOUNT_TYPE
        account_id = 1
        result = mock("result")
        Cart.stub(:get_account_cart).with(account_id).and_return result
        Cart.get_cart(type, account_id).should == result
      end
 
      it "should get account cart" do
        type = Cart::SESSION_TYPE
        session_id = "xxx"
        result = mock("result")
        Cart.stub(:get_session_cart).with(session_id).and_return result
        Cart.get_cart(type, session_id).should == result
      end
    end

    describe "#session_cart" do
      it "#should return session cart" do
        session_id = mock("Session ID")
        cart = mock("Cart")
        Cart.should_receive(:find_by_session_id).with(session_id).and_return cart
        Cart.session_cart(session_id).should == cart
      end
    end

    describe "#destroy_expired_carts" do
      it "should destroy all expired session carts" do
        Cart.should_receive(:destroy_all)
        Cart.destroy_expired_carts
      end
    end
  end
end
