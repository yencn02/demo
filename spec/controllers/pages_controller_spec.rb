require 'spec_helper'

describe PagesController do

  #Delete this example and add some real ones
  it "should use PagesController" do
    controller.should be_an_instance_of(PagesController)
  end

  describe "#show" do
    it "should be render show" do
      VideoPack.should_receive(:feature_items).and_return mock("feature_items")
      video_home = mock_model(Video)
      Video.stub(:find_by_featured_home).with(true).and_return video_home
      video_format = mock("video_format")
      video_home.stub(:formats).stub(:first).and_return video_format
      get :show
      response.should render_template(:default)
    end
  end


  describe "#howto" do
    it "should be render howto" do
      VideoPack.should_receive(:feature_items).and_return mock("feature_items")      
      get :howto
      response.should render_template(:howto)
    end
  end
  
#    @video_packs = VideoPack.feature_items(2)
#    @video_home = Video.find_by_featured_home(true)
#    @video_home = Video.find(:first) if @video_home.nil?
#    unless params[:video_format].blank?
#        @video_home.formats.each {|video_format| @video_format = video_format if video_format.name.eql?(params[:video_format]) }
#    else
#        @video_format = @video_home.formats.first unless @video_home.formats.blank?
#    end
#
#    @feature_categories = Category.feature_category
#    render :action => params[:page] || 'default'

end
