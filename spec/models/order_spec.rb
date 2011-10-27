require 'spec_helper'

describe Order do
  describe "Instance Methods" do

    before :each do
      @order = Order.new
    end

    describe "#total_amount_in_cents" do
      it "should set new value for total_amount_in_cents" do
        total_amount_in_cents = rand(100)
        @order.should_receive(:calculate_total_amount_in_cents).and_return total_amount_in_cents
        @order.total_amount_in_cents.should == total_amount_in_cents
      end

      it "should set new value for total_amount_in_cents" do
        total_amount_in_cents = rand(100)
        @order.stub(:total_amount_in_cents).and_return total_amount_in_cents
        @order.should_not_receive(:calculate_total_amount_in_cents)
        @order.total_amount_in_cents.should == total_amount_in_cents
      end

    end

    describe "#to_label" do

      it "should return lable" do
        id = rand(100)
        @order.stub(:id).and_return id
        @order.to_label.should == "Order ##{id}"
      end
      
    end

    describe "#add_items" do

      it "should add_items to order" do
        line_items = []
        (rand(10) + 1).times do
          line_items << mock_model(LineItem)
        end

        ordered_line_items = []

        line_items.each do |line_item|
          ordered_line_item = mock_model(OrderedLineItem)
          OrderedLineItem.should_receive(:init_ordered_line_item).with(line_item).and_return ordered_line_item
          ordered_line_items << ordered_line_item
        end
        @order.add_items(line_items)
        @order.ordered_line_items.should == ordered_line_items
      end

    end

    describe "#calculate_total_amount_in_cents" do
      it "should calculate total amount in cents" do
        total = 0
        ordered_line_items = Array.new
        (rand(100)+1).times do
          subtotal = rand(100)
          line_item = mock_model(OrderedLineItem)
          line_item.stub(:subtotal_in_cents).and_return(subtotal)
          ordered_line_items << line_item

          total += subtotal
        end

        @order.stub(:ordered_line_items).and_return(ordered_line_items)

        @order.calculate_total_amount_in_cents.should == total
      end
    end

    describe "#to_hash" do
      it "should to_hash" do
        @order.stub(:approval_code).and_return mock("approval code")
        shipping_address = mock_model(AddressBook)
        @order.stub(:shipping_address).and_return shipping_address
        shipping_address.stub(:to_hash).and_return mock("Shipping Hash")
        ordered_line_items = []
        (rand(10)+1).times do
          line_item = mock_model(OrderedLineItem, :to_hash => mock("LineItem hash"))
          ordered_line_items << line_item
        end
        @order.stub(:ordered_line_items).and_return ordered_line_items
        hash = {
          "ApprovalCode" => @order.approval_code,
          "TransactionInformation" => {
            "OrderShippingInformation" => @order.shipping_address.to_hash
          },
          "OrderProducts" => {"OrderProduct" => []}
        }
        ordered_line_items.each do |line_item|
          hash["OrderProducts"]["OrderProduct"] << line_item.to_hash
        end
        @order.to_hash.should == hash
      end
    end

    describe "#send_acutrack_request" do

      it "should update order number" do
        hash = mock("Order's hash")
        @order.should_receive(:to_hash).and_return hash
        xml = mock("XML")
        AcutrackRequest.should_receive(:build_order_xml).with(hash).and_return xml
        response = mock("Response")
        AcutrackRequest.should_receive(:post_data).with(xml).and_return response
        message = {:order_number => mock("order_number"), "some" => "thing"}
        AcutrackRequest.should_receive(:get_response_messages).with(response).and_return message
        @order.should_receive(:set_order_number).with(message[:order_number])
        @order.send_acutrack_request.should == message
      end

      it "should not update order number" do
        hash = mock("Order's hash")
        @order.should_receive(:to_hash).and_return hash
        xml = mock("XML")
        AcutrackRequest.should_receive(:build_order_xml).with(hash).and_return xml
        response = mock("Response")
        AcutrackRequest.should_receive(:post_data).with(xml).and_return response
        message = {"some" => "thing"}
        AcutrackRequest.should_receive(:get_response_messages).with(response).and_return message
        @order.should_not_receive(:set_order_number)
        @order.send_acutrack_request.should == message
      end
      
    end

    describe "#set_order_number" do
      it "should set_order_number" do
        number = mock("a number")
        @order.should_receive(:order_number=).with(number)
        result = mock("result")
        @order.should_receive(:save).and_return result
        @order.set_order_number(number).should == result
      end
    end

  end

  describe "Class Methods" do

    describe "#create_order" do

      it "should create order" do
        billing_address = mock_model(AddressBook)
        shipping_address = mock_model(AddressBook)
        
        cart = mock_model(Cart, :account_id => rand(100), :billing_address => billing_address,
          :shipping_address => shipping_address, :credit_card_id => rand(100), :total_in_cents => rand(100),
          :line_items => mock("List of line items"))

        billing_address.should_receive(:to_order).and_return billing_address
        shipping_address.should_receive(:to_order).and_return shipping_address


        order = mock_model(Order)
        approval_code = mock("Time")
        Time.stub(:now).and_return approval_code
        approval_code.should_receive(:to_i).and_return approval_code
        Order.should_receive(:new).with(:account_id => cart.account_id, :billing_address => billing_address,
          :shipping_address => shipping_address, :credit_card_id => cart.credit_card_id,
          :total_amount_in_cents => cart.total_in_cents,
          :approval_code => approval_code, :status => Order::STATUS_NEW).and_return order

        order.should_receive(:add_items).with(cart.line_items)

        order.should_receive(:save).and_return true

        Order.create_order(cart).should == order
      end

    end

    describe "#update_tracking_number" do

      it "should do nothing" do
        args = {
          :dealer_id => mock("dealer_id"),
          :approval_code => mock("approval_code"),
          :tracking_number => mock("tracking_number")
        }
        Order.should_not_receive(:find_by_approval_code)
        Order.update_tracking_number(args).should == false
      end

      it "order found" do
        args = {
          :dealer_id => DEALER_ID,
          :approval_code => mock("approval_code"),
          :tracking_number => mock("tracking_number")
        }
        order = mock_model(Order, :account => mock_model(Account, :user => mock_model(User)))
        Order.should_receive(:find_by_approval_code).with(args[:approval_code]).and_return order
        order.should_receive(:tracking_number=).with(args[:tracking_number])
        result = mock("result")
        order.should_receive(:save).and_return result
        order.stub(:tracking_number).and_return nil
        Mailer.should_receive(:deliver_notify_tracking_number).with(order.account.user, order)
        Order.update_tracking_number(args).should == result
      end

      it "order could not be found" do
        args = {
          :dealer_id => DEALER_ID,
          :approval_code => mock("approval_code"),
          :tracking_number => mock("tracking_number")
        }
        order = nil
        Order.should_receive(:find_by_approval_code).with(args[:approval_code]).and_return order
        Order.update_tracking_number(args).should == false
      end
      
    end

  end
end
