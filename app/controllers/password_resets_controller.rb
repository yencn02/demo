class PasswordResetsController < ApplicationController
  before_filter :require_no_user  
  before_filter :load_user_using_perishable_token, :only => [:edit, :update]
  before_filter :cart_items

  
  def new
    render
  end

  def create
    @user = User.find_by_email(params[:email])
    if @user
      @user.deliver_password_reset_instructions!
      flash[:info] = "Instructions to reset your password have been emailed to you. " +
        "Please check your email."
      redirect_to root_url
    else
      flash[:error] = "No user was found with that email address"
      render :action => :new
    end
  end

  def edit
    #render
  end

  def update
    @user.password = params[:password]
    @user.password_confirmation = params[:password_confirmation]    
    if @user.save
      flash[:info] = "Password successfully updated"
      redirect_to account_url
    else
      flash[:info] = "Password confirm not match"
      render :action => :edit
    end
  end

  private
  def load_user_using_perishable_token
    @user = User.find_using_perishable_token(params[:id])    
    unless @user
      flash[:notice] = "We're sorry, but we could not locate your account. " +
        "If you are having issues try copying and pasting the URL " +
        "from your email into your browser or restarting the " +
        "reset password process."
      redirect_to root_url
    end
  end
  
  def cart_items
    cart = load_cart
    @cart_items = cart.newest_items(2)
  end
end
