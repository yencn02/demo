require 'spec_helper'

describe Promo do

  describe "Instance Methods" do
    
    before :each do
      @promo = Promo.new
    end

    describe "#discounted_price_in_cents" do

      it "case discount_type == amount" do
        price = mock_model(Price)
        @promo.stub(:discount_type).and_return "amount"
        price.stub(:amount_in_cents).and_return rand(100)
        discount_amount_in_cents = rand(10)
        @promo.should_receive(:discount_amount_in_cents).and_return discount_amount_in_cents
        @promo.discounted_price_in_cents(price).should == price.amount_in_cents - discount_amount_in_cents
      end

      it "case discount_type == percentage" do
        price = mock_model(Price)
        @promo.stub(:discount_type).and_return "percentage"
        price.stub(:amount_in_cents).and_return rand(100)
        discount_percentage = rand(10)
        @promo.should_receive(:discount_percentage).and_return discount_percentage
        @promo.discounted_price_in_cents(price).should == (price.amount_in_cents.to_f * discount_percentage) / 100.0
      end
      
    end

    describe "#discounted_price" do

      it "should discounted_price" do
        price = mock_model(Price)
        discounted_price = rand(100)
        @promo.should_receive(:discounted_price_in_cents).with(price).and_return discounted_price
        @promo.discounted_price(price).should == Money.new(discounted_price)
      end
      
    end

  end

end
