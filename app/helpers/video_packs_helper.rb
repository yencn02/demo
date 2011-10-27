module VideoPacksHelper
  def persisted_search_video_packs_path(options)
    persist_params = params.dup
    persist_params.delete(:controller)
    persist_params.delete(:action)
    persist_params.delete(:page)

    video_packs_path(persist_params.merge(options))
  end
end
