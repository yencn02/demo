class CartController < ApplicationController
  before_filter :get_cart

  def update_items
    if params[:action_] == "save_changes"
      if params[:cart]
        params[:cart].each do |k,v|
          @cart.add_or_update(k.to_i, v.to_i)
        end
      end
      redirect_to cart_account_path
    else
      redirect_to(session[:shopping_url].nil? ? videos_path : session[:shopping_url])
    end
  end

  def add_item
    if params[:price_id]
      @cart.add_or_update(params[:price_id])
    end
    redirect_to cart_account_path
  end

  def remove_item
    if params[:price_id]
      @cart.remove(params[:price_id])
    end
    redirect_to cart_account_path
  end

  #  def save_for_later
  #    if params[:price_id]
  #      @cart.save_for_later(params[:price_id])
  #    end
  #    redirect_to cart_account_path
  #  end

  #  def move_to_cart
  #    if params[:price_id]
  #      @cart.move_to_cart(params[:price_id])
  #    end
  #    redirect_to saved_items_account_path
  #  end
  
  def set_shipping_info
    if params[:address_id]
      @cart.set_shipping_info(params[:address_id].to_i)
      redirect_to billing_address_account_path
    else
      @address_book = AddressBook.find_or_new(params[:address_book], @cart.buyer)
      render :update do |page|
        if @address_book.save
          @cart.set_shipping_info(@address_book.id)
          page.redirect_to confirm_order_account_path
        else
          page.show "#message-wraper"
          page.replace_html "#message-wraper", error_messages_for('address_book', :object => @address_book)
        end
      end
    end
  end

  def set_billing_info
    params[:credit_card].merge!(params[:date])
    params[:credit_card][:first_name] = params[:address_book][:first_name]
    params[:credit_card][:last_name] = params[:address_book][:last_name]
    params[:user].merge!(params[:address_book]) if params[:user]
    if params[:edit] == "address"
      object = save_billing_address(params[:address_book], params[:user])
    else
      object = save_billing_info(params[:credit_card], params[:address_book], params[:user])
    end
    render :update do |page|
      if object.errors.size > 0
        page.show "#message-wraper"
        page.replace_html "#message-wraper", error_messages_for('address_book', :object => object)
        page.call "Address.resizeWindow"
      else
        if !@cart.has_no_download_videos? || @cart.shipping_address
          page.redirect_to confirm_order_account_path
        else
          page.redirect_to shipping_address_account_path
        end
      end
    end
  end
  

  def checkout
    render :update do |page|
      if @cart.check_balance(session[:credit_card])
        total_amount = @cart.process_to_checkout(session[:credit_card])
        flash[:info] = "Thanks!  You have successfully completed your order.  You will receive a receipt for this purchase via the email address you've provided.  The email will also contain product shipping information and/or information on how to download and use our media products."
        flash[:total_value] = total_amount.to_f
        page.redirect_to purchases_account_path
      else
        page.show "#app-message"
        page.replace_html "#app-message .bad", "Sorry, your bank has not authorized this transaction.  Please try again with another form of payment."
        page.show "#app-message .bad"
      end
    end
  end

  protected

  def get_cart
    @cart = load_cart
  end

  def save_billing_address(params_address_book, params_user, credit_card = nil)
    if user = current_user
      buyer = user.account
    elsif params_user
      buyer = AnonymousUser.find_or_new(params_user)
      return buyer unless buyer.save
    end
    address_book = AddressBook.find_or_new(params_address_book, buyer)
    if address_book.save
      session[:credit_card] = credit_card if credit_card
      @cart.set_billing_info(address_book.id, buyer)
    end
    return address_book
  end

  def save_billing_info(params_credit_card, params_address_book, params_user)
    credit_card = CreditCard.new(params_credit_card)
    credit_card_am = credit_card.validate
    if credit_card_am.errors.size > 0
      return credit_card_am
    else
      return save_billing_address(params_address_book, params_user, credit_card)
    end
  end
end
