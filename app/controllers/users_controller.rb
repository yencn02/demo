class UsersController < ApplicationController
  before_filter :require_no_user, :only => [:new, :create, :login_no_download]
  before_filter :require_user, :only => [:edit, :information, :show, :update]
  before_filter :no_cache, :only => [:cart, :shipping_address, :billing_address, :confirm_order, :purchases]
  def cart
    Cart.destroy_expired_carts
    @cart = load_cart
    @line_items = @cart.line_items.paginate(:page => params[:page], :per_page => 5)
  end

  #  def saved_items
  #    @cart = load_cart
  #    render :action => :saved_items, :layout => 'application_obsolete'
  #  end

  def shipping_address
    @cart = load_cart
    if @cart.empty?
      redirect_to cart_account_path
    end
    unless @cart.billing_address
      redirect_to billing_address_account_path
    end
    @billing_address = @cart.billing_address
    @address_books = []
    user = current_user
    @address_books = user.account.address_books if user
    if @cart.shipping_address
      @address_book = @cart.shipping_address.clone
    else
      @address_book = AddressBook.new_based_on_account(user)
    end
  end

  def billing_address
    @cart = load_cart
    if @cart.empty?
      redirect_to cart_account_path
    end
    @card_types = CardType.all
    if @cart.billing_address
      @address_book = @cart.billing_address.clone
      @email = @cart.buyer_email
    else
      @address_book = AddressBook.new_based_on_account(current_user)
    end
  end

  def remove_address
    if params[:address_id]
      address = AddressBook.find(params[:address_id])
      address.destroy
    end
    redirect_to :action => :shipping_address
  end

  def confirm_order
    @cart = load_cart
    if @cart.empty?
      redirect_to cart_account_path
    elsif @cart.has_no_download_videos? && @cart.shipping_address.nil?
      redirect_to shipping_address_account_path
    elsif @cart.billing_address.nil?
      redirect_to billing_address_account_path
    else
      @line_items = @cart.line_items.paginate(:page => params[:page], :per_page => 5)
    end
  end

  def new
    if params[:return] == "checkout"
      session[:return_to] = billing_address_account_path
    end
    @user = User.new
    @user.account = Account.new
  end

  def create
    @user = User.new(params[:user])
    @user.account ||= Account.create
    if @user.save
      flash[:info] = "Account registered!"
      Cart.update_account_cart(cookies[request.session_options[:key]], @user.id)
      redirect_to information_account_url
    else
      render :action => :new
    end
  end
  
  def login_no_download
    render :layout => false
  end


  def show
    @user = @current_user
    redirect_to information_account_url
  end

  def information
    @user = @current_user
    @cart = load_cart
  end

  def update
    @user = current_user # makes our views "cleaner" and more consistent
    @cart = load_cart
    if @user.update_attributes(params[:user])
      flash[:info] = "Account updated!"
    end
    render :action => :information
  end

  def purchases
    page = params[:page] || 1
    @orders = load_orders(page)
    cart = load_cart
    @cart_items = cart.newest_items(2)
  end

  private
  def no_cache
    response.headers["Cache-Control"] = "no-cache, no-store, max-age=0, must-revalidate"
    response.headers["Pragma"] = "no-cache"
  end
  
end
