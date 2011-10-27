class OrderedLineItem < ActiveRecord::Base
  belongs_to :order
  belongs_to :product, :polymorphic => true
  composed_of :unit_price, :class_name => 'Money', :mapping => [%w(unit_price_in_cents cents), %w(currency currency)]
  composed_of :subtotal, :class_name => 'Money', :mapping => [%w((unit_price_in_cents * quantity) cents), %w(currency currency)]
  after_save :update_video_purchase_count

  def update_video_purchase_count
    if product.respond_to?(:video_pack)
      video_pack = product.video_pack
      video_pack.increment_purchase_count!
      video_pack.videos.each(&:increment_purchase_count!)
    elsif product.respond_to?(:video)
      product.video.increment_purchase_count!
    end
  end

  def to_hash
    {
      "ProductID" => self.product.acutrack_sku,
      "ProductQuantity" => self.quantity
    }
  end

  def order_product
    return self.product.video if self.product.respond_to?(:video)
    return self.product.video_pack if self.product.respond_to?(:video_pack)
  end

  def subtotal_in_cents
    unit_price_in_cents * quantity
  end

  def subtotal
    Money.new(subtotal_in_cents)
  end

  def is_download?
    result = false
    if self.product && self.product.is_downloadable
      result = true
    end
    result
  end

  def videos
    if self.product_type == "VideoPackFormat"
      self.product.video_pack.videos.collect { |x| x.title }.join(", ")
    end
  end

  def to_label
    self.product.to_label if self.product
  end

  class << self
    def init_ordered_line_item(line_item)
      item = self.new(
        :product => line_item.product,
        :price => line_item.price.amount_in_cents,
        :unit_price_in_cents => line_item.unit_price_in_cents,
        :currency => line_item.currency,
        :quantity => line_item.quantity,
        :product_title => line_item.product.title,
        :product_description => line_item.product.description
      )
      if promo = line_item.promo
        item.promo_discount_type = promo.discount_type
        item.promo_discount_amount_in_cents = promo.discount_amount_in_cents
        item.promo_discount_percentage = promo.discount_percentage
      end
      return item
    end
  end
end