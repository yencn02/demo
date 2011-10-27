require 'spec_helper'

describe VideoStat do
  fixtures :videos

  before(:each) do
    @valid_attributes = {
      :video_id => videos(:central_park).id
    }
  end

  it "should create a new instance given valid attributes" do
    VideoStat.create!(@valid_attributes)
  end

  it "should increment the video view count cache" do
    VideoStat.create!(@valid_attributes)
    videos(:central_park).reload.view_count.should > 0
  end
end
