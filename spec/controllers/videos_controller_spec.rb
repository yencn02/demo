require 'spec_helper'

describe VideosController do

  #Delete this example and add some real ones
  it "should use VideosController" do
    controller.should be_an_instance_of(VideosController)
  end

  describe "#index" do
    it "should return array videos" do      
      Video.should_receive(:browse_by).and_return mock("videos")
      get :index
      response.should render_template(:index)
    end
  end
  
#  describe "#show" do
#    it "should be play with format DVD" do
#      VideoPack.should_receive(:feature_items).and_return mock("feature_items")
#      video= mock_model(Video)
#      current_user = mock_model(User, :account => mock_model(Account))
#      controller.should_receive(:current_user).twice.and_return current_user
#      Video.stub(:find).with("1").and_return(video)
#      purchase = mock("purchase")
#      video.stub(:purchased?).with(current_user).and_return purchase
#      formats = Array.new
#      (rand(4)+1).times do
#        formats << mock_model(VideoFormat, :name => "DVD", :cdn_url => "http://test.com/test.mp4")
#      end
#      video.stub(:formats).and_return formats
#      video_format = mock("video_format")
#      formats.each do |video_format|
#        video_format.stub(:name).and_return "DVD"
#        video_format = video_format
#      end
#      get :show, :id => "1", :video_format => "DVD"
#      response.should render_template(:show)
#    end
#
#    it "should be play with the first format" do
#      VideoPack.should_receive(:feature_items).and_return mock("feature_items")
#      video= mock_model(Video)
#      Video.stub(:find).with("1").and_return(video)
#
#      formats = Array.new
#      (rand(4)+1).times do
#        formats << mock_model(VideoFormat, :name => "ipod", :cdn_url => "http://test.com/test.mp4")
#      end
#      video.stub(:formats).and_return formats
#      video_format = mock("video_format")
#      formats.stub(:blank?).and_return true
#      formats.stub(:first).and_return video_format
#      get :show, :id => "1"
#      response.should render_template(:show)
#    end
#  end

end
