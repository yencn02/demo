require 'spec_helper'

describe VideoPacksController do

  #Delete this example and add some real ones
  it "should use VideoPacksController" do
    controller.should be_an_instance_of(VideoPacksController)
  end
  
  
  describe "#index" do
    it "should return array videos" do      
      VideoPack.should_receive(:browse_by).and_return mock("video_packs")
      get :index
      response.should render_template(:index)
    end
  end
  
  describe "#show" do
    it "should be render show" do
      VideoPack.should_receive(:feature_items).and_return mock("feature_items")
      video_pack = mock_model(VideoPack)
      VideoPack.stub(:find).with("1").and_return(video_pack)
      get :show, :id => "1"      
      response.should render_template(:show)
    end
  end

  describe "#playlist" do
    it "should be render playlist" do      
      video_pack = mock_model(VideoPack)
      VideoPack.should_receive(:find).and_return(video_pack)
      video_pack.should_receive(:playlist).and_return mock("playlist")
      get :playlist
      response.should render_template(:playlist)
    end
  end

end
