require 'spec_helper'

describe OrderedLineItem do

  describe "Instance Methods" do

    before :each do
      @line_item = OrderedLineItem.new
    end

    describe "#update_video_purchase_count" do

      before :each do
        @product = mock("product")
        @line_item.stub(:product).and_return @product
      end

      it "should increment_purchase_count from video_pack" do
        @product.should_receive(:respond_to?).with(:video_pack).and_return true
        videos = []
        rand(10).times do
          video = mock_model(Video)
          video.should_receive(:increment_purchase_count!).and_return mock("increment result")
          videos << video
        end
        video_pack = mock_model(VideoPack)
        video_pack.should_receive(:videos).and_return videos
        video_pack.should_receive(:increment_purchase_count!)
        @product.should_receive(:video_pack).and_return video_pack
        @line_item.update_video_purchase_count
      end

      it "should increment_purchase_count from object that have :video method" do
        @product.should_receive(:respond_to?).with(:video_pack).and_return false
        @product.should_receive(:respond_to?).with(:video).and_return true
        video = mock_model(Video)
        video.should_receive(:increment_purchase_count!).and_return mock("increment result")
        @product.should_receive(:video).and_return video
        @line_item.update_video_purchase_count
      end

      it "should do nothing" do
        @product.should_receive(:respond_to?).with(:video_pack).and_return false
        @product.should_receive(:respond_to?).with(:video).and_return false
        @product.should_not_receive(:video_pack)
        @product.should_not_receive(:video)
        @line_item.update_video_purchase_count
      end
      
    end

  end

  describe "Class Methods" do

    describe "#init_ordered_line_item" do
      
      before :each do
        @line_item = mock_model(LineItem,
          :product => mock("product", :title => "title #{rand(100)}", :description => "description #{rand(100)}"),
          :price => mock_model(Price, :amount_in_cents => rand(100)),
          :unit_price_in_cents => rand(100),
          :currency => mock("currency"),
          :quantity => rand(10)
        )
        
        @item = mock_model(OrderedLineItem)
        
        OrderedLineItem.should_receive(:new).with(
          :product => @line_item.product,
          :price => @line_item.price.amount_in_cents,
          :unit_price_in_cents => @line_item.unit_price_in_cents,
          :currency => @line_item.currency,
          :quantity => @line_item.quantity,
          :product_title => @line_item.product.title,
          :product_description => @line_item.product.description
        ).and_return @item
      end

      it "should return a new item wihout promo info" do
        @line_item.should_receive(:promo).and_return nil
        @item.should_not_receive(:promo_discount_type=)
        @item.should_not_receive(:promo_discount_amount_in_cents=)
        @item.should_not_receive(:promo_discount_percentage=)
        OrderedLineItem.init_ordered_line_item(@line_item)
      end

      it "should return a new item with promo info" do
        promo = mock_model(Promo, :discount_type => mock("discount_type"),
                                  :discount_amount_in_cents => rand(100),
                                  :discount_percentage => mock("float"))
        @line_item.should_receive(:promo).and_return promo
        @item.should_receive(:promo_discount_type=).with(promo.discount_type)
        @item.should_receive(:promo_discount_amount_in_cents=).with(promo.discount_amount_in_cents)
        @item.should_receive(:promo_discount_percentage=).with(promo.discount_percentage)
        OrderedLineItem.init_ordered_line_item(@line_item)
      end
      
    end
    
  end
  
end
