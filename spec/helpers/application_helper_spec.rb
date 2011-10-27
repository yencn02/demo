require 'spec_helper'

describe ApplicationHelper do

  it "#current_nav_item" do
    regex = mock("regex")
    content = mock("content")
    tag_name = mock("tag_name")
    current_class = mock("current_class")
    helper.should_receive(:content_tag).with(tag_name, block_given? ? yield : content, :class => (current_class if request.path =~ regex))
    helper.current_nav_item(regex, content, tag_name, current_class)
  end

  describe "#display cart_image_from(line_item)" do
    it "should display image video" do
      line_item = mock("line_item")
      product = mock("product")
      line_item.stub(:product).and_return product
      product.stub(:respond_to?).with(:video).and_return true
      product.stub(:respond_to?).with(:videos).and_return false
      helper.cart_image_from(line_item).should == image_tag( 'video-preview.gif')
    end

    it "should display image video pack" do
      line_item = mock("line_item")
      product = mock("product")
      line_item.stub(:product).and_return product
      product.stub(:respond_to?).with(:video).and_return false
      product.stub(:respond_to?).with(:videos).and_return true
      helper.cart_image_from(line_item).should == image_tag( 'video-pack-preview.gif')
    end
  end

  describe "#video_format_image_for(format)" do
    it "should display image format bluray video" do
      format = mock("format")
      format.should_receive(:name).and_return "bluray"
      helper.video_format_image_for(format).should == image_tag('video-format-bluray.gif')
    end
    
    it "should display image format dvd video" do
      format = mock("format")
      format.should_receive(:name).and_return "dvd"
      helper.video_format_image_for(format).should == image_tag('video-format-dvd.gif')
    end
    
    it "should display image format ipod video" do
      format = mock("format")
      format.should_receive(:name).and_return "ipod"
      helper.video_format_image_for(format).should == image_tag('video-format-ipod.gif')
    end
    
    it "should display image format download video" do
      format = mock("format")
      format.should_receive(:name).and_return "download"
      helper.video_format_image_for(format).should == image_tag('video-format-download.gif')
    end
  end


  describe "#video_format_image_source(format)" do
    it "should display image format bluray video" do
      format = mock("format")
      format.should_receive(:name).and_return "bluray"
      helper.video_format_image_source(format).should == 'video-format-bluray.gif'
    end

    it "should display image format dvd video" do
      format = mock("format")
      format.should_receive(:name).and_return "dvd"
      helper.video_format_image_source(format).should == 'video-format-dvd.gif'
    end

    it "should display image format ipod video" do
      format = mock("format")
      format.should_receive(:name).and_return "ipod"
      helper.video_format_image_source(format).should == 'video-format-ipod.gif'
    end

    it "should display image format download video" do
      format = mock("format")
      format.should_receive(:name).and_return "download"
      helper.video_format_image_source(format).should == 'video-format-download.gif'
    end
  end


  describe "#image_source(source, default_source = DEFAULT_VIDEO_IMAGE)" do
    it "should display default source" do
      source = mock("source")
      default_source = mock("default_source")
      source.should_receive(:blank?).and_return true
      helper.image_source(source, default_source).should == default_source
    end

    it "should display source" do
      source = mock("source")
      default_source = mock("default_source")
      source.should_receive(:blank?).and_return false
      helper.image_source(source, default_source).should == source
    end
  end


  describe "#video_categories(video)" do
    it "should display video" do
      video = mock_model(Video)
      categories = mock_model(Category)
      video.stub(:categories).and_return categories
      result = mock("result")
      categories.stub(:collect).and_return result
      result_to_sentence = mock("result_to_sentence")
      result.stub(:to_sentence).and_return result_to_sentence
      helper.video_categories(video).should == result_to_sentence
    end
  end

  it "#load_states" do
    carmen_states = Carmen::STATES
    state_options = {"Default" => options_for_select(["", ""])}
    for i in 0...carmen_states.size
      country = carmen_states[i][0]
      states = carmen_states[i][1]
      state_options[country] = options_for_select(states)
    end
    helper.load_states(carmen_states).should == javascript_tag("var states = #{state_options.to_json}")
  end

  describe "#state_from_country" do
    it "should return a state with selected value" do
      selected_country = "AU"
      selected = ["New South Wales", "NSW"]
      carmen_states = Carmen::STATES
      for i in 0...carmen_states.size
        country = carmen_states[i][0]
        if country == selected_country
          states = options_for_select carmen_states[i][1], {:selected => selected}
          break
        end
      end
      helper.state_from_country(selected_country, selected).should == states
    end

    it "should return the default state" do
      selected_country = "XX"
      selected = ["New South Wales", "NSW"]
      states = options_for_select ["", ""], {:selected => ["", ""]}
      helper.state_from_country(selected_country, selected).should == states
    end
  end

  it "#state_form_column" do
    record = mock("record", :state => "NSW", :country => "AU")
    input = mock("input")
    selected = [Carmen::state_name(record.state), record.state]
    states = mock("states")
    helper.should_receive(:state_from_country).with(record.country, selected).and_return states
    expected_result = mock("expected_result")
    helper.should_receive(:select).with(:record, :state, states, {:selected => selected}, {:class => "state-input"}).and_return expected_result
    helper.state_form_column(record, input).should == expected_result
  end

end
