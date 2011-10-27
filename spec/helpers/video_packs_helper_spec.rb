require 'spec_helper'

describe VideoPacksHelper do

  it "#persisted_search_video_packs_path" do
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
    path = video_packs_path(persist_params.merge(options)).gsub("&", "&amp;")
    helper.persisted_search_video_packs_path(options).should == path
  end

end
