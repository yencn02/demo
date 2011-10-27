module VideosHelper
  def persisted_search_path(options)
    persist_params = params.dup
    persist_params.delete(:controller)
    persist_params.delete(:action)
    persist_params.delete(:page)
    search_path(persist_params.merge(options))
  end

  def search_filter_class(options)
    'current' if params[options.keys.first] == options.values.first || (params[options.keys.first].blank? and options[:default])
  end

  def duration_from_seconds(seconds)
    ChronicDuration.output(seconds)
  end
end
