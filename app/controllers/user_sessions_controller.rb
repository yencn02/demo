class UserSessionsController < ApplicationController
  before_filter :require_no_user, :only => [:new, :create]
  before_filter :require_user, :only => :destroy

  def new
    @user_session = UserSession.new
  end

  def create
    @user_session = UserSession.new(params[:user_session])    
    if @user_session.save
      if User.is_admin(@user_session)        
        redirect_back_or_default admin_users_path
      else        
        Cart.update_account_cart(cookies[request.session_options[:key]], session["user_credentials_id"])
        flash[:notice] = "Login successful!"
        redirect_back_or_default information_account_url
      end
    else
      render :action => :new
    end
  end

  def ajax_create
    @user_session = UserSession.new(params[:user_session])
    render :update do |page|
      if @user_session.save
        Cart.update_account_cart(cookies[request.session_options[:key]], session["user_credentials_id"])
        if User.is_admin(@user_session)
          page.redirect_to admin_users_path
        elsif params[:login_checkout] == "true"
          page.redirect_to billing_address_account_url
        else
          page.reload
        end
      else
        page.show "#facebox #error-message"
        page.replace_html "#facebox #error-message", error_messages_for(:user_session, :header_message => "authentication failed", :message => "", :class => 'errorExplanation corner')
      end
    end
  end

  def destroy
    current_user_session.destroy

    flash[:notice] = "Logout successful!"

    redirect_to root_url
  end
  
end
