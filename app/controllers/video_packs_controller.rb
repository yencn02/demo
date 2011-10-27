class VideoPacksController < ApplicationController
  before_filter :cart_items

  def index
    session[:shopping_url] = url_for(params)
    @filter = params[:filter] || "recent"
    @category = params[:category] || "all"
    @video_packs = VideoPack.browse_by(@filter, @category, params[:search], params[:page])
  end

  def show
    session[:shopping_url] = url_for(params) if params[:id] != "none"
    @video_packs = VideoPack.feature_items(2)
    @video_pack = VideoPack.find(params[:id])
    @feature_videos = Video.feature_items(2)
    @video_pack.update_view_count
  end

  def playlist
    video_pack = VideoPack.find(params[:id])    
    @playlist = video_pack.playlist
    render :layout => false
  end

  private

  def cart_items
    cart = load_cart
    @cart_items = cart.newest_items(2)
  end
end
