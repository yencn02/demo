require 'spec_helper'

describe VideoPack do
  fixtures :videos, :video_packs

  before(:each) do
    @valid_attributes = {
      :title => "New York City",
      :description => "Pack of videos from around New York City.",
      :image_file_name => "new_york.jpg",
      :image_content_type => "image/jpg",
      :image_file_size => 1000,
      :image_updated_at => Time.now
    }
  end

  it "should create a new instance given valid attributes" do
    VideoPack.create!(@valid_attributes)
  end

  it "should generate a slug based on the title" do
    video_pack = VideoPack.create!(@valid_attributes)
    video_pack.slug.should == video_pack.title.parameterize
  end

  it "should have and belong to many videos" do
    video_pack = VideoPack.create!(@valid_attributes)
    video_pack.videos << videos(:central_park)
    video_pack.videos.reload.should_not be_empty
  end

  it "should filter by top selling" do
    VideoPack.by_filter('top_selling').first.purchase_count.should > VideoPack.by_filter('top_selling').last.purchase_count
  end

  it "should filter by most recent" do
    VideoPack.by_filter('most_recent').first.published_at.should > VideoPack.by_filter('most_recent').last.published_at
  end

  it "should find a video when searching by title" do
    VideoPack.title_like('california').should_not be_empty
  end

  it "should find a video when searching by title or description" do
    VideoPack.with_search('california').should_not be_empty
  end

  it "should return all videos when a search term is not present" do
    VideoPack.with_search.should_not be_empty
  end

  it "should allow browsing with filters, categories, length, search, and pagination" do
    VideoPack.browse_by('most-popular', 'california', 1).should_not be_empty
    VideoPack.browse_by('most-popular', 'california', nil).should_not be_empty
    VideoPack.browse_by('most-popular', nil, nil).should_not be_empty
    VideoPack.browse_by(nil, nil, nil).should_not be_empty
  end

  describe "Instance Methods" do
    
    before :each do
      @video_pack = VideoPack.new
    end

    describe "#increment_purchase_count!" do
      it "should increment_purchase_count" do
        purchase_count = rand(100)
        @video_pack.should_receive(:purchase_count).and_return purchase_count
        result = mock("result")
        @video_pack.should_receive(:update_attribute).with(:purchase_count, purchase_count + 1).and_return result
        @video_pack.increment_purchase_count!.should == result
      end
    end

    describe "#to_param" do
      it "should return params" do
        id = rand(100)
        @video_pack.stub(:id).and_return id
        slug = mock("slug")
        @video_pack.stub(:slug).and_return slug
        @video_pack.to_param.should == "#{id}-#{slug}"
      end
    end

    describe "#image_thumb_path" do
      it "should return an empty string" do
        @video_pack.should_receive(:image_file_name).and_return String.new
        @video_pack.image_thumb_path.should == String.new
      end

      it "should return an image path" do
        @video_pack.should_receive(:image_file_name).and_return mock("file name")
        image = mock("Image")
        @video_pack.should_receive(:image).and_return image
        url = mock("url")
        image.should_receive(:url).with(:thumb, include_updated_timestamp = false).and_return url
        @video_pack.image_thumb_path.should == url
      end
    end

    describe "#image_medium_path" do
      it "should return an empty string" do
        @video_pack.should_receive(:image_file_name).and_return String.new
        @video_pack.image_medium_path.should == String.new
      end

      it "should return an image path" do
        @video_pack.should_receive(:image_file_name).and_return mock("file name")
        image = mock("Image")
        @video_pack.should_receive(:image).and_return image
        url = mock("url")
        image.should_receive(:url).with(:medium, include_updated_timestamp = false).and_return url
        @video_pack.image_medium_path.should == url
      end
    end

    describe "#image_large_path" do
      it "should return an empty string" do
        @video_pack.should_receive(:image_file_name).and_return String.new
        @video_pack.image_large_path.should == String.new
      end

      it "should return an image path" do
        @video_pack.should_receive(:image_file_name).and_return mock("file name")
        image = mock("Image")
        @video_pack.should_receive(:image).and_return image
        url = mock("url")
        image.should_receive(:url).with(:large, include_updated_timestamp = false).and_return url
        @video_pack.image_large_path.should == url
      end
    end

    describe "#duration_in_seconds" do
      it "should calculate duration_in_seconds" do
        total = 0
        videos = Array.new
        (rand(100)+1).times do
          duration = rand(100)
          videos << mock_model(Video, :duration_in_seconds => duration)
          total += duration
        end
        @video_pack.should_receive(:videos).and_return videos
        @video_pack.duration_in_seconds.should == total
      end
    end

    describe "#average_duration" do
      it "should calculate average_duration" do
        videos = mock("videos", :size => rand(100) + 2)
        @video_pack.should_receive(:videos).and_return videos
        duration = rand(100) + 10
        @video_pack.should_receive(:duration_in_seconds).and_return duration
        average = duration/videos.size
        @video_pack.average_duration.should == average - (average % 60)
      end

      it "should calculate average_duration" do
        videos = [mock("videos")]
        @video_pack.should_receive(:videos).and_return videos
        duration = rand(100) + 10
        @video_pack.should_receive(:duration_in_seconds).and_return duration
        @video_pack.average_duration.should == duration
      end

    end

    describe "#categories" do
      it "should return categories" do
        videos = Array.new
        (rand(100)+1).times do
          categories = Array.new
          (rand(10)+1).times do
            categories << mock("categories", :name => "categories #{rand(10)}")
          end
          videos << mock_model(Video, :categories => categories)
        end
        
        cats = []
        videos.each do |video|
          video.categories.collect { |cat| cats << cat.name }
        end
        @video_pack.should_receive(:videos).and_return videos
        @video_pack.categories.should == cats.uniq!
      end
    end

    describe "#playlist" do
      it "should return xml - full video" do
        videos = Array.new
        video_pack = VideoPack.create!(@valid_attributes)
        track = []
        user = mock("user")
        (rand(10)+1).times do
          videos << mock_model(Video,:title => "Running Balboa Park in the Winter")
        end
        video_pack.stub(:videos).and_return videos

        videos.each do |video|
          formats = Array.new
          (rand(4)+1).times do
            formats << mock_model(VideoFormat, :name => "ipod", :cdn_url => "http://test.com/test.mp4")
          end
          video.stub(:formats).and_return formats

          first_format = mock("first_format")
          formats.stub(:first).and_return first_format
          video.stub(:purchased?).with(user).and_return true
          url = mock("url")
          first_format.stub(:url).and_return url
         
          title = mock("title")
          video.stub(:title).and_return title
          track << { "title" => title, "location" => url }
        end

        hash = {
          "playlist" => {
            "trackList" => {"track" => track}
          }
        }
        hash[:attributes!] = { "playlist" => {"version" => "1", "xmlns" => "http://xspf.org/ns/0/" } }
        xml = hash.to_soap_xml
        video_pack.playlist(user).should == xml
      end

      it "should return xml - demo video" do
        videos = Array.new
        video_pack = VideoPack.create!(@valid_attributes)
        track = []
        user = mock("user")
        (rand(10)+1).times do
          videos << mock_model(Video,:title => "Running Balboa Park in the Winter")
        end
        video_pack.stub(:videos).and_return videos

        videos.each do |video|
          formats = Array.new
          (rand(4)+1).times do
            formats << mock_model(VideoFormat, :name => "ipod", :cdn_url => "http://test.com/test.mp4")
          end
          video.stub(:formats).and_return formats

          first_format = mock("first_format")
          formats.stub(:first).and_return first_format
          video.stub(:purchased?).with(user).and_return false
          url = mock("url")
          video.stub(:url).and_return url

          title = mock("title")
          video.stub(:title).and_return title
          track << { "title" => title, "location" => url }
        end

        hash = {
          "playlist" => {
            "trackList" => {"track" => track}
          }
        }
        hash[:attributes!] = { "playlist" => {"version" => "1", "xmlns" => "http://xspf.org/ns/0/" } }
        xml = hash.to_soap_xml
        video_pack.playlist(user).should == xml
      end
    end

    describe "#feature_items" do
      it "should return feature video packs" do
        limit = rand(100)
        results = mock("Results")
        VideoPack.should_receive(:find).with(:all, :conditions => {:is_featured => true}, :limit => limit, :order => "created_at DESC").and_return results
        VideoPack.feature_items(limit).should == results
      end
    end
    
  end
end
