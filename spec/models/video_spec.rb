require 'spec_helper'

describe Video do
  fixtures :videos, :categories

  before(:each) do
    @valid_attributes = {
      :title => "Central Park Stroll",      
      :description => "This is a video of a run through Central Park in New York City, NY.",
      :duration_in_seconds => 1800,
      :published_at => Date.today,
      :image_file_name => "central_park.jpg",
      :image_content_type => "image/jpg",
      :image_file_size => 1000,
      :image_updated_at => Time.now,
      :demo_url => "demo.mp4"
    }
  end

  it "should create a new instance given valid attributes" do
    Video.create!(@valid_attributes)
  end

  it "should generate a slug based on the title" do
    video = Video.create!(@valid_attributes)
    video.slug.should == video.title.parameterize
  end

  it "should have access to categorizables and categories" do
    video = Video.create!(@valid_attributes)
    Categorizable.create!(:category => categories(:cycling), :categorized => video)
    video.categorizables.should_not be_empty
    video.categories.should_not be_empty
  end

  it "should filter by top selling" do
    Video.by_filter('top_selling').first.purchase_count.should > Video.by_filter('top_selling').last.purchase_count
  end

  it "should filter by most views" do
    Video.by_filter('most_viewed').first.view_count.should > Video.by_filter('most_viewed').last.view_count
  end

  it "should filter by most recent" do
    Video.by_filter('most_recent').first.published_at.should > Video.by_filter('most_recent').last.published_at
  end
  
  it "should filter by featured" do
    video = Factory(:video, :is_featured => true)
    Video.by_filter("featured").should include(video)
  end

  it "should find of a category" do
    categories(:cycling).categorizables.create(:categorized => videos(:central_park))

    Video.of_category('Cycling').should_not be_empty
  end

  it "should find of a category filtered by most views" do
    categories(:cycling).categorizables.create(:categorized => videos(:central_park))
    categories(:cycling).categorizables.create(:categorized => videos(:brooklyn_bridge))

    Video.by_filter('most_views').of_category('Cycling').should_not be_empty
    Video.by_filter('most_views').of_category('Cycling').first.view_count.should > Video.by_filter('most_views').of_category('Cycling').last.view_count
  end

  it "should find a video when searching by title" do
    Video.title_like('central').should_not be_empty
  end

  it "should find a video when searching by description" do
    Video.description_like('run').should_not be_empty
  end

  it "should find a video when searching by title or description" do
    Video.with_search('run').should_not be_empty
  end

  it "should find a video when searching and filter by most views" do
    Video.with_search('this').by_filter('most_views').should_not be_empty
    Video.with_search('this').by_filter('most_views').first.view_count.should > Video.with_search('this').by_filter('most_views').last.view_count
  end

  it "should return all videos when a search term is not present" do
    Video.with_search.should_not be_empty
  end

  it "should filter by video length" do
    Video.within_length('-30').should_not be_empty
    Video.within_length('15-60').should_not be_empty
    Video.within_length('90-').should be_empty
  end

  it "should allow browsing with filters, categories, length, search, and pagination" do
    categories(:cycling).categorizables.create(:categorized => videos(:central_park))

    Video.browse_by('most-popular', 'Cycling', '30-40', 'this', 1).should_not be_empty
    Video.browse_by('most-popular', 'Cycling', '30-40', 'this', nil).should_not be_empty
    Video.browse_by('most-popular', 'Cycling', '30-40', nil, nil).should_not be_empty
    Video.browse_by('most-popular', 'Cycling', nil, nil, nil).should_not be_empty
    Video.browse_by('most-popular', nil, nil, nil, nil).should_not be_empty
    Video.browse_by(nil, nil, nil, nil, nil).should_not be_empty
  end

  it "should return url demo" do
    video = Video.create!(@valid_attributes)
    video.url.should == URL_DEMO + video.demo_url
  end


  describe "Instance Methods" do

    before :each do
      @video = Video.new
    end

    describe "#increment_purchase_count!" do
      it "should increment_purchase_count" do
        purchase_count = rand(100)
        @video.should_receive(:purchase_count).and_return purchase_count
        result = mock("result")
        @video.should_receive(:update_attribute).with(:purchase_count, purchase_count + 1).and_return result
        @video.increment_purchase_count!.should == result
      end
    end

    describe "#to_param" do
      it "should return params" do
        id = rand(100)
        @video.stub(:id).and_return id
        slug = mock("slug")
        @video.stub(:slug).and_return slug
        @video.to_param.should == "#{id}-#{slug}"
      end
    end

    describe "#image_thumb_path" do
      it "should return an empty string" do
        @video.should_receive(:image_file_name).and_return String.new
        @video.image_thumb_path.should == String.new
      end

      it "should return an image path" do
        @video.should_receive(:image_file_name).and_return mock("file name")
        image = mock("Image")
        @video.should_receive(:image).and_return image
        url = mock("url")
        image.should_receive(:url).with(:thumb, include_updated_timestamp = false).and_return url
        @video.image_thumb_path.should == url
      end
    end

    describe "#image_medium_path" do
      it "should return an empty string" do
        @video.should_receive(:image_file_name).and_return String.new
        @video.image_medium_path.should == String.new
      end

      it "should return an image path" do
        @video.should_receive(:image_file_name).and_return mock("file name")
        image = mock("Image")
        @video.should_receive(:image).and_return image
        url = mock("url")
        image.should_receive(:url).with(:medium, include_updated_timestamp = false).and_return url
        @video.image_medium_path.should == url
      end
    end

    describe "#image_large_path" do
      it "should return an empty string" do
        @video.should_receive(:image_file_name).and_return String.new
        @video.image_large_path.should == String.new
      end

      it "should return an image path" do
        @video.should_receive(:image_file_name).and_return mock("file name")
        image = mock("Image")
        @video.should_receive(:image).and_return image
        url = mock("url")
        image.should_receive(:url).with(:large, include_updated_timestamp = false).and_return url
        @video.image_large_path.should == url
      end
    end

    describe "#purchased?(user)" do
      it "nil user object" do
        user = nil
        @video.purchased?(user).should == false
      end
      
      it "purchased as format" do
        orders = mock("list of order")
        orders.should_receive(:all).with(:select => :id).and_return orders
        account = mock_model(Account, :orders => orders)
        user = mock_model(User, :account => account)
        @video.stub(:purchased_as_format?).with(orders).and_return true
        @video.purchased?(user).should == true
      end

      it "purchased in pack" do
        orders = mock("list of order")
        orders.should_receive(:all).with(:select => :id).and_return orders
        account = mock_model(Account, :orders => orders)
        user = mock_model(User, :account => account)
        @video.stub(:purchased_as_format?).with(orders).and_return false
        expected_result = mock("result")
        @video.stub(:purchased_in_pack?).with(orders).and_return expected_result
        @video.purchased?(user).should == expected_result
      end
    end

    describe "purchased_as_format?(orders)" do
      before :each do
        @formats = []
        (rand(10) + 1).times do |index|
          @formats << mock_model(VideoFormat, :id => index)
        end
        @orders = []
        (rand(10) + 1).times do |index|
          @orders << mock_model(Order, :id => index)
        end
        @video.stub(:formats).and_return @formats
      end
      
      it "should return false" do
        items = []
        OrderedLineItem.should_receive(:all).with(:conditions => {
            :order_id => @orders.map{|x| x.id},
            :product_id => @formats.map{|x| x.id},
            :product_type => "VideoFormat" }).and_return items
        @video.purchased_as_format?(@orders).should == false
      end

      it "should return true" do
        items = [mock("item")]
        OrderedLineItem.should_receive(:all).with(:conditions => {
            :order_id => @orders.map{|x| x.id},
            :product_id => @formats.map{|x| x.id},
            :product_type => "VideoFormat" }).and_return items
        @video.purchased_as_format?(@orders).should == true
      end
    end

    describe "purchased_in_pack?(orders)" do
      before :each do
        @orders = []
        (rand(10) + 1).times do |index|
          @orders << mock_model(Order, :id => index)
        end
        video_packs = []
        (rand(10) + 1).times do |index|
          formats = []
          (rand(10) + 1).times do |i|
            formats << mock_model(VideoPackFormat)
          end
          video_packs << mock_model(VideoPack, :formats => formats)
        end
        @video.stub(:video_packs).and_return video_packs
        @video_pack_formats = []
        video_packs.each do |pack|
          @video_pack_formats.concat(pack.formats)
        end
      end

      it "should return false" do
        items = []
        OrderedLineItem.should_receive(:all).with(:conditions => {
        :order_id => @orders.map{|x| x.id},
        :product_id => @video_pack_formats.map{|x| x.id},
        :product_type => "VideoPackFormat" }).and_return items
        @video.purchased_in_pack?(@orders).should == false
      end

      it "should return true" do
        items = [mock("item")]
        OrderedLineItem.should_receive(:all).with(:conditions => {
        :order_id => @orders.map{|x| x.id},
        :product_id => @video_pack_formats.map{|x| x.id},
        :product_type => "VideoPackFormat" }).and_return items
        @video.purchased_in_pack?(@orders).should == true
      end
    end
    
  end

  describe "Class Methods" do

  end

end
