class ApplicationController < ActionController::Base
  helper :all
  protect_from_forgery

  filter_parameter_logging :password, :password_confirmation
  helper_method :current_user_session, :current_user
  


  rescue_from Exception, :with => :rescue_all_exceptions

  def rescue_all_exceptions(exception)
    render :template => "shared/404" unless exception.blank?
  end

  

  # Below are the main methods for persisting the user session and handling login/logout flow
  private
  def current_user_session
    return @current_user_session if defined?(@current_user_session)
    @current_user_session = UserSession.find
  end

  def current_user
    return @current_user if defined?(@current_user)
    @current_user = current_user_session && current_user_session.record
  end

  def require_user
    unless current_user
      store_location
      flash[:notice] = "You must be logged in to access this page"
      redirect_to new_session_url
      return false
    end
  end

  def require_no_user
    if current_user
      store_location
      flash[:notice] = "You must be logged out to access this page"
      redirect_to information_account_url
      return false
    end
  end

  def current_user_admin
    return @current_user if defined?(@current_user)
    @current_user = current_user_session && current_user_session.record
    @current_user ? @current_user.is_admin : nil
  end


  def require_admin
    unless current_user_admin      
      flash.now[:error] = "You're not authorized to access the page"
      redirect_to login_url
      return false
    end
  end

  def store_location
    session[:return_to] = request.request_uri
  end

  def redirect_back_or_default(default)
    redirect_to(session[:return_to] || default)
    session[:return_to] = nil
  end
  
  def load_cart
    unless current_user
      cart = Cart.get_cart(Cart::SESSION_TYPE, cookies[request.session_options[:key]])
    else
      cart = Cart.get_cart(Cart::ACCOUNT_TYPE, current_user.account.id)
    end
    return cart
  end

  def load_orders(page = 1)
    user = current_user
    unless user
      orders = Order.by_session(cookies[request.session_options[:key]], page)
    else
      orders = Order.by_user(user.account.id, page)
    end
    return orders
  end
end
