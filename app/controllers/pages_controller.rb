class PagesController < ApplicationController
  before_filter :cart_items, :only => [:howto, :show]
  
  def show
    @video_packs = VideoPack.feature_items(2)
    @video_home = Video.find_by_featured_home(true)    
    @video_home = Video.find(:first) if @video_home.nil?
    unless params[:video_format].blank?
      @video_home.formats.each {|video_format| @video_format = video_format if video_format.name.eql?(params[:video_format]) }
    else
      @video_format = @video_home.formats.first unless @video_home.formats.blank?
    end
    
    @feature_categories = Category.feature_category
    render :action => params[:page] || 'default'
  end

  def howto    
    @video_packs = VideoPack.feature_items(2)
    @video_url = URL_DEMO + "HowToUseVA.mp4"
  end

  def playlist
    videos = Video.find(:all, :conditions => { :featured_home => true })
    videos = Video.find(:all, :limit => 3) if videos.blank?
    @playlist = Video.playlist(videos)
    render :layout => false
  end

  def cart_items
    cart = load_cart
    @cart_items = cart.newest_items(2)
  end

end
