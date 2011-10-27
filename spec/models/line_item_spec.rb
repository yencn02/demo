require 'spec_helper'

describe LineItem do
  fixtures :video_packs, :video_formats, :videos, :prices, :promos

  describe "xxx" do
    before(:each) do
      @valid_attributes = {
        :cart_id => 1,
        :product_id => video_formats(:central_park_download).id,
        :product_type => 'VideoFormat',
        :price_id => prices(:central_park_download).id,
        :currency => "USD",
        :quantity => 1
      }
    end

    it "should create a new instance given valid attributes" do
      LineItem.create!(@valid_attributes)
    end

    it "should set the unit price as the price amount" do
      line_item = LineItem.create!(@valid_attributes)
      line_item.unit_price_in_cents.should == prices(:central_park_download).amount_in_cents
      line_item.unit_price.should == prices(:central_park_download).amount
    end

    it "should determine subtotal based on unit price and quantity" do
      line_item = LineItem.new
      line_item.quantity = 5
      line_item.unit_price_in_cents = 3000
      line_item.subtotal.should == Money.new(line_item.quantity * line_item.unit_price_in_cents)
      line_item.subtotal.format.should == '$150.00'
    end

    it "should apply a percentage discount when promo is present" do
      line_item = LineItem.create!(@valid_attributes.merge(:promo_id => promos(:central_park_download_sale).id))
      line_item.unit_price_in_cents.should == prices(:central_park_download).amount_in_cents.to_f * 0.2
    end

    it "should apply an amount discount when promo is present" do
      line_item = LineItem.create!(@valid_attributes.merge(:promo_id => promos(:central_park_download_amount_sale).id))
      line_item.unit_price_in_cents.should == prices(:central_park_download).amount_in_cents - 1000
    end
  end
  
  describe "Instance Methods" do

    before :each do
      @line_item = LineItem.new
    end

    describe "#cart_product" do

      it "should return video" do
        product = mock("product", :video => mock("video"))
        @line_item.stub(:product).and_return product
        @line_item.product.should_receive(:respond_to?).with(:video).and_return true
        @line_item.cart_product.should == product.video
      end

      it "should return product" do
        product = mock("product", :video_pack => mock("video_pack"))
        @line_item.stub(:product).and_return product
        @line_item.product.should_receive(:respond_to?).with(:video).and_return false
        @line_item.product.should_receive(:respond_to?).with(:video_pack).and_return true
        @line_item.cart_product.should == product.video_pack
      end

      it "should return nil" do
        product = mock("product", :video => mock("video"))
        @line_item.stub(:product).and_return product
        @line_item.product.should_receive(:respond_to?).with(:video).and_return false
        @line_item.product.should_receive(:respond_to?).with(:video_pack).and_return false
        @line_item.cart_product.should == nil
      end

    end
    
  end
  
end
