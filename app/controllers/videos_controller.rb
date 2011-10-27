class VideosController < ApplicationController
  before_filter :cart_items, :only => [:index, :show]
  def index
    @filter = params[:filter] || "recent"
    @category = params[:category] || "all"
    @videos = Video.browse_by(@filter, @category, params[:length], params[:search], params[:page])
  end

  def show    
    session[:shopping_url] = url_for(params) if params[:id] != "none"
    @video_packs = VideoPack.feature_items(2)
    @video = Video.find(params[:id])    
    @feature_videos = Video.feature_items(2)
    @video.update_view_count(request.ip.to_s)
    unless params[:video_format].blank?
      @video.formats.each {|video_format| @video_format = video_format if video_format.name.eql?(params[:video_format]) }
    else
      @video_format = @video.formats.first unless @video.formats.blank?
    end
  end

  private

  def cart_items
    cart = load_cart
    @cart_items = cart.newest_items(2)
  end
end
