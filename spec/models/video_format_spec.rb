require 'spec_helper'

describe VideoFormat do
  fixtures :videos

  describe "xxx" do
    before(:each) do
      format = Format.create(:name => "720p")
      price = Price.new(:amount_in_cents => (rand(10) + 1))
      @valid_attributes = {
        :format => format,
        :price => price,
        :details => "720p Hi-Def video download",
        :is_downloadable => true,
        :download_file_name => "central_park_hd_720p.mpg",
        :download_content_type => "video/mpeg",
        :download_file_size => 132342,
        :download_updated_at => Time.now,
        :video_id => videos(:central_park).id,
        :cdn_url => "video.mp4"
      }
    end

    it "should create a new instance given valid attributes" do
      VideoFormat.create!(@valid_attributes)
    end

    it "should require a downlod if it is downloadable" do
      format = Format.create(:name => "720p")
      video = VideoFormat.new({
          :format => format,
          :details => "720p Hi-Def video download",
          :is_downloadable => true,
          :video_id => videos(:central_park).id,
          :cdn_url => "video.mp4"
        })

      video.should_not be_valid
    end

    it "should not require a download if it is not downloadable" do
      format = Format.create(:name => "DVD")
      price = Price.new(:amount_in_cents => (rand(10) + 1))
      VideoFormat.create!({
          :format => format,
          :price => price,
          :details => "DVD of Central Park.",
          :is_downloadable => false,
          :video_id => videos(:central_park).id,
          :cdn_url => "video.mp4"
        })
    end

    it "should be return url valid" do
      video_format = VideoFormat.create!(@valid_attributes)
      time = Time.now.to_i + 24 * 60 * 60
      md5 = "#{SECRET_KEY}#{URL_STORE}#{video_format.cdn_url.strip}?e=#{time}"
      hash = Digest::MD5.hexdigest(md5)
      video_format.url.should == "#{URL_STORE}#{video_format.cdn_url.strip}?e=#{time}&h=#{hash}"
    end

  end

  describe "Instance Methods" do

    before :each do
      @format = VideoPackFormat.new
    end

    describe "#title" do
      it "should return title" do
        video_pack = mock_model(VideoPack, :title => mock("Videopack's title"))
        @format.should_receive(:video_pack).and_return video_pack
        format_name = mock("Format's name")
        @format.stub(:name).and_return format_name
        @format.title.should == "#{video_pack.title} - #{format_name}"
      end
    end

    describe "#description" do
      it "should return video description" do
        video_pack = mock_model(VideoPack, :description => mock("Videopack's description"))
        @format.should_receive(:video_pack).and_return video_pack
        @format.description.should == video_pack.description
      end
    end

    describe "product_code" do
      it "should return product_code" do
        video_pack = mock_model(VideoPack, :id => rand(100))
        @format.should_receive(:video_pack).and_return video_pack
        @format.stub(:id).and_return rand(100)
        @format.product_code.should == "VDO-PK-#{video_pack.id}-#{@format.id}"
      end
    end

    it "#name" do
      format = mock_model(Format, :name => "DVD")
      @format.stub(:format).and_return format
      @format.name.should == format.name
    end

  end

  describe "Class Methods" do
    
  end
end
