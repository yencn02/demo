class Cart < ActiveRecord::Base
  SESSION_TYPE = "Session"
  ACCOUNT_TYPE = "Account"
  belongs_to :buyer, :polymorphic => true

  belongs_to :billing_address, 
    :class_name  => "AddressBook",
    :foreign_key => "billing_address_id"

  belongs_to :shipping_address,
    :class_name  => "AddressBook",
    :foreign_key => "shipping_address_id"

  has_many :line_items, 
    :conditions => {:billing_later => false},
    :dependent => :delete_all

  has_many :saved_items,
    :class_name => "LineItem",
    :conditions => {:billing_later => true},
    :dependent => :delete_all

  composed_of :total, :class_name => 'Money', :mapping => [%w(total cents), %w(currency currency)]

  def empty?
    self.line_items.empty?
  end

  def find_item(price_id)
    self.line_items.first(:conditions => {:price_id => price_id})
  end

  def add_or_update(price_id, quantity = nil)
    q = (quantity.to_i == 0 ? 1 : quantity)
    if line_item = find_item(price_id)
      line_item[:quantity] = q if quantity
    else
      line_item = LineItem.new(:cart_id => self.id, :price_id => price_id, :quantity => 1)
      line_item.product = line_item.price.product
      line_item.unit_price_in_cents = line_item.price.amount_in_cents
    end
    line_item.save
  end

  def total_in_cents
    self.line_items.collect(&:subtotal_in_cents).sum
  end

  def total_items
    self.line_items.collect(&:quantity).sum
  end
  
  def total
    Money.new(total_in_cents)
  end

  def remove(price_id)
    if line_item = find_item(price_id)
      line_item.destroy
    end
  end

  def save_for_later(price_id)
    if line_item = find_item(price_id)
      line_item.billing_later = true
      line_item.save
    end
  end

  def move_to_cart(price_id)
    if line_item = self.saved_items.first(:conditions => {:price_id => price_id})
      line_item.billing_later = false
      line_item.save
    end
  end

  def set_shipping_info(address_id)
    self.shipping_address_id = address_id
    self.remove_oldest_address
    self.save
  end

  def set_billing_info(address_id, buyer)
    self.billing_address_id = address_id
    self.remove_oldest_address
    self.buyer = buyer
    self.save
  end

  def check_balance(credit_card)
    gateway = ActiveMerchant::Billing::AuthorizeNetGateway.new(:login => LOGIN_ID, :password=> TRANSACTION_KEY)
    creditcard  = ActiveMerchant::Billing::CreditCard.new(
      :first_name => credit_card.first_name,
      :last_name  => credit_card.last_name,
      :month      => credit_card.expiration_month,
      :year       => credit_card.expiration_year,
      :type       => credit_card.card_type.code,
      :number     => credit_card.card_number
    )
    if self.shipping_address
      shipper_ady = {
        :first_name => self.shipping_address.first_name,
        :last_name => self.shipping_address.last_name,
        :city => self.shipping_address.city,
        :address1 => self.shipping_address.address1,
        :address2 => self.shipping_address.address2,
        :country => self.shipping_address.country,
        :zip => self.shipping_address.zipcode,
        :state => self.shipping_address.state
      }
    else
      shipper_ady = {}
    end
    biller_ady = {
      :first_name => self.billing_address.first_name,
      :last_name => self.billing_address.last_name,
      :city => self.billing_address.city,
      :address1 => self.billing_address.address1,
      :address2 => self.billing_address.address2,
      :country => self.billing_address.country,
      :zip => self.billing_address.zipcode,
      :state => self.billing_address.state
    }
    options = {:email => self.buyer_email, :billing_address => biller_ady, :shipping_address => shipper_ady }
    response = gateway.authorize(self.total_in_cents,creditcard, options)
    warn response.to_json
    response.success?
  end

  def capture(credit_card)
    gateway = ActiveMerchant::Billing::AuthorizeNetGateway.new(:login => LOGIN_ID, :password=> TRANSACTION_KEY)
    creditcard  = ActiveMerchant::Billing::CreditCard.new(
      :first_name => credit_card.first_name,
      :last_name  => credit_card.last_name,
      :month      => credit_card.expiration_month,
      :year       => credit_card.expiration_year,
      :type       => credit_card.card_type.code,
      :number     => credit_card.card_number
    )
    if self.shipping_address
      shipper_ady = {
        :first_name => self.shipping_address.first_name,
        :last_name => self.shipping_address.last_name,
        :city => self.shipping_address.city,
        :address1 => self.shipping_address.address1,
        :address2 => self.shipping_address.address2,
        :country => self.shipping_address.country,
        :zip => self.shipping_address.zipcode,
        :state => self.shipping_address.state
      }
    else
      shipper_ady = {}
    end

    biller_ady = {
      :first_name => self.billing_address.first_name,
      :last_name => self.billing_address.last_name,
      :city => self.billing_address.city,
      :address1 => self.billing_address.address1,
      :address2 => self.billing_address.address2,
      :country => self.billing_address.country,
      :zip => self.billing_address.zipcode,
      :state => self.billing_address.state
    }

    options = {:email => self.buyer_email, :billing_address => biller_ady, :shipping_address => shipper_ady }
		gateway.capture(self.total_in_cents,creditcard, options)
  end
  
  def reset
    self.line_items = []
    self.save
  end

  def to_order
    order = Order.create_order(self)
    self.reset
    return order
  end

  def merge_items(line_items)
    line_items.each do |item|
      quantity = 0
      if line_item = self.find_item(item.price.id)
        quantity = line_item.quantity
      end
      self.add_or_update(item.price.id, item.quantity + quantity)
    end
  end
  
  def to_account_cart(account)
    cart = account.cart
    unless cart.nil?
      cart.merge_items(self.line_items)
      self.destroy
    else
      self.session_id = nil
      self.buyer_id = account.id
      self.buyer_type = account.class.name
      self.cart_type = Cart::ACCOUNT_TYPE
      self.save
    end
  end

  def inuse_addresses
    inuse = []
    inuse << self.billing_address_id if self.billing_address_id
    inuse << self.shipping_address_id if self.shipping_address_id
    inuse
  end
  
  def remove_oldest_address
    inuse = self.inuse_addresses
    addresses = AddressBook.find(:all,
      :conditions => {:in_use => false, :buyer_id => self.buyer_id, :buyer_type => self.buyer.class.name}, :order => "updated_at")
    num_of_addresses = addresses.size
    if num_of_addresses > AddressBook::ADDRESSES_PER_ACCOUNT
      addresses.delete_if{|x| inuse.index(x.id)}
      num_of_deleted_items =  num_of_addresses - AddressBook::ADDRESSES_PER_ACCOUNT
      for i in 0..num_of_deleted_items
        addresses[i].destroy if addresses[i]
      end
    end
  end

  def newest_items(limit)
    LineItem.find(:all, :conditions => {:billing_later => false, :cart_id => id}, :limit => limit, :order => "created_at DESC")
  end

  def process_to_checkout(credit_card)
    capture(credit_card)
    order = to_order
    if order.has_no_download_videos?
      order.send_acutrack_request
    end
    Mailer.deliver_notify_order_number(order, credit_card)
    return order.total_amount_in_cents
  end

  def buyer_email
    if self.buyer.respond_to?(:email)
      email = self.buyer.email
    else
      email = self.buyer.user.email
    end
    return email
  end

  def has_download_videos?
    has_download_videos = false
    line_items.each do |line_item|
      if line_item.is_download?
        has_download_videos = true
        break
      end
    end
    has_download_videos
  end

  def has_no_download_videos?
    has_no_download_videos = false
    line_items.each do |line_item|
      unless line_item.is_download?
        has_no_download_videos = true
        break
      end
    end
    has_no_download_videos
  end

  class << self

    def get_session_cart(session_id)
      cart = self.find_by_session_id(session_id) if session_id
      unless cart
        cart = self.create(:session_id => session_id, :cart_type => SESSION_TYPE)
      end
      return cart
    end

    def get_account_cart(account_id)
      account = Account.find(account_id)
      cart = account.cart
      unless cart
        cart = self.create(:buyer => account)
      end
      return cart
    end

    def get_cart(type, owner_id)
      case type
      when ACCOUNT_TYPE
        get_account_cart(owner_id)
      else
        get_session_cart(owner_id)
      end
    end

    def session_cart(session_id)
      self.find_by_session_id(session_id)
    end

    def destroy_expired_carts
      self.destroy_all(["created_at < ? and cart_type = ?", 2.days.ago, Cart::SESSION_TYPE])
    end

    def update_account_cart(session_id, user_id)
      cart = Cart.session_cart(session_id)
      unless cart.nil?
        account = Account.find_by_user_id(user_id)
        cart.to_account_cart(account)
      end
    end
    
  end
end