require 'spec_helper'

describe VideoPackFormat do

  describe "Instance Methods" do

    before :each do
      @format = VideoFormat.new
    end

    describe "#title" do
      it "should return title" do
        video = mock_model(Video, :title => mock("Video's title"))
        @format.should_receive(:video).and_return video
        format_name = mock("Format's name")
        @format.stub(:name).and_return format_name
        @format.title.should == "#{video.title} - #{format_name}"
      end
    end

    describe "#description" do
      it "should return video description" do
        video = mock_model(Video, :description => mock("Video's description"))
        @format.should_receive(:video).and_return video
        @format.description.should == video.description
      end
    end
    
    it "#name" do
      format = mock_model(Format, :name => "DVD")
      @format.stub(:format).and_return format
      @format.name.should == format.name
    end

    describe "product_code" do
      it "should return product_code" do
        video = mock_model(Video, :id => rand(100))
        @format.should_receive(:video).and_return video
        @format.stub(:id).and_return rand(100)
        @format.product_code.should == "VDO-#{video.id}-#{@format.id}"
      end
    end

  end
  
end