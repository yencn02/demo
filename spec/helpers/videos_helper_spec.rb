require 'spec_helper'

describe VideosHelper do
  it "#persisted_search_path" do
    options = {
      :option1 => "option1",
      :option2 => "option2"
    }
    params = {
      :controller => "controller",
      :action => "action",
      :page => "page"
    }
    persist_params = params.dup
    persist_params.delete(:controller)
    persist_params.delete(:action)
    persist_params.delete(:page)
    path = search_path(persist_params.merge(options)).gsub("&", "&amp;")
    helper.persisted_search_path(options).should == path
  end

  it "#duration_from_seconds" do
    seconds = rand(100) + 1
    helper.duration_from_seconds(seconds).should == ChronicDuration.output(seconds)
  end

  describe "#search_filter_class" do
    it "#should return nil" do
      options = {"option1" => "value1"}
      helper.search_filter_class(options).should == nil
    end

    it "#should return 'current'" do
      options = {"option1" => "value1"}
      params["option1"] = "value1"
      helper.search_filter_class(options).should == "current"
    end
  end
end
