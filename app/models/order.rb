class Order < ActiveRecord::Base

  default_scope :order => "created_at desc", :conditions => ["buyer_id is not null"]
  belongs_to :buyer, :polymorphic => true
  has_many :ordered_line_items
  belongs_to :shipping_address, :class_name  => "AddressBook", :foreign_key => "shipping_address_id"
  belongs_to :billing_address, :class_name  => "AddressBook", :foreign_key => "billing_address_id"

  composed_of :total_amount, :class_name => 'Money', :mapping => [%w(total_amount_in_cents cents), %w(currency currency)]
  
  STATUS = "new"

  def total_amount_in_cents
    self[:total_amount_in_cents] ||= calculate_total_amount_in_cents
  end

  def calculate_total_amount_in_cents
    ordered_line_items.collect(&:subtotal_in_cents).sum
  end

  def to_label
    "Order ##{id}"
  end

  def add_items(line_items)
    line_items.each{ |line_item|
      ordered_line_item = OrderedLineItem.init_ordered_line_item(line_item)
      self.ordered_line_items << ordered_line_item
    }
  end

  def to_hash
    hash = {}
    hash["ApprovalCode"] = self.approval_code
    hash["TransactionInformation"] = {
      "OrderShippingInformation" => self.shipping_address.to_hash
    }
    hash["OrderProducts"] = {"OrderProduct" => []}
    self.ordered_line_items.each do |line_item|
      unless line_item.is_download?
        if line_item.product_type == "VideoFormat"
          hash["OrderProducts"]["OrderProduct"] << line_item.to_hash
        elsif line_item.product_type == "VideoPackFormat"
          line_item.order_product.videos.each{|video|
            video_format = video.get_video_format(line_item.product.format_id)
            hash["OrderProducts"]["OrderProduct"] << {
              "ProductID" => video_format.acutrack_sku,
              "ProductQuantity" => 1
            }
          }
        end
      end
    end
    return hash
  end

  def send_acutrack_request
    xml = AcutrackRequest.build_order_xml(self.to_hash)
    response = AcutrackRequest.post_data(xml)
    message = AcutrackRequest.get_response_messages(response)
    self.set_order_number(message[:order_number]) if message[:order_number]
    return message
  end

  def set_order_number(number)
    self.order_number = number
    self.save
  end

  def total_items
    self.ordered_line_items.collect(&:quantity).sum
  end

  def has_download_videos?
    has_download_videos = false
    ordered_line_items.each do |line_item|
      if line_item.is_download?
        has_download_videos = true
        break
      end
    end
    has_download_videos
  end

  def has_no_download_videos?
    has_no_download_videos = false
    ordered_line_items.each do |line_item|
      unless line_item.is_download?
        has_no_download_videos = true
        break
      end
    end
    has_no_download_videos
  end

  def to_csv(csv)
    index = 0
    ordered_line_items.each do |item|
      unless item.is_download?
        index += 1
        product_id = item.product.acutrack_sku if item.product
        csv << [
          self.approval_code, index, product_id, item.quantity,
          self.shipping_address.first_name,
          self.shipping_address.last_name,
          self.shipping_address.address1,
          self.shipping_address.address2,
          self.shipping_address.city,
          self.shipping_address.state,
          self.shipping_address.zipcode,
          self.shipping_address.country,
          nil,nil, self.shipping_address.shipping_type_id
        ]
      end
    end
  end

  def buyer_email

    if buyer.is_a?(Account)
      buyer.user.email if buyer.user
    elsif buyer.is_a?(AnonymousUser)
      buyer.email if buyer
    else
      ""
    end
  end

  class << self

    def by_user(account_id, page, per_page = 5)
      paginate(:conditions => {:buyer_id => account_id, :buyer_type => "Account"}, :page => page, :per_page => per_page, :order => "created_at DESC")
    end

    def by_session(session_id, page, per_page = 5)
      if session_id
        paginate(:conditions => {:session_id => session_id}, :page => page, :per_page => per_page, :order => "created_at DESC")
      end
    end
    
    def create_order(cart)
      billing_address = cart.billing_address.to_order
      shipping_address = cart.shipping_address.to_order if cart.shipping_address
      order = self.new(
        :buyer => cart.buyer,
        :billing_address => billing_address,
        :shipping_address => shipping_address,
        :total_amount_in_cents => cart.total_in_cents,
        :session_id => cart.session_id,
        :approval_code => Time.now.to_i
      )
      order.add_items(cart.line_items)
      order.save
      return order
    end

    def update_tracking_number(args)
      result = false
      if args[:dealer_id] == DEALER_ID && args[:approval_code] && args[:tracking_number]
        order = Order.find_by_approval_code(args[:approval_code])
        if order && !order.tracking_number
          order.tracking_number = args[:tracking_number]
          result = order.save
          Mailer.deliver_notify_tracking_number(order)
        else
          result = (order.nil? ? false : true)
        end
      end
      return result
    end
    
  end

end
