class LineItem < ActiveRecord::Base
  cattr_reader :per_page
  @@per_page = 10

  before_validation :set_product_from_price

  validates_presence_of :product, :price, :unit_price_in_cents, :quantity

  belongs_to :cart
  belongs_to :product, :polymorphic => true
  belongs_to :price
  belongs_to :promo
  
  composed_of :unit_price, :class_name => 'Money', :mapping => [%w(unit_price_in_cents cents), %w(currency currency)]
  composed_of :subtotal, :class_name => 'Money', :mapping => [%w((unit_price_in_cents * quantity) cents), %w(currency currency)]

  def unit_price_in_cents
    self[:unit_price_in_cents] ||= calculate_unit_price_in_cents
  end

  def subtotal_in_cents
    unit_price_in_cents * quantity
  end

  def subtotal
    Money.new(subtotal_in_cents)
  end

  def cart_product
    return self.product.video if self.product.respond_to?(:video)
    return self.product.video_pack if self.product.respond_to?(:video_pack)
  end

  def is_download?
    result = false
    if self.product_type == "VideoFormat" && self.product && self.product.is_downloadable
      result = true
    end
    result
  end

  protected
  
    def set_product_from_price
      self.product ||= price.product
    end

    def calculate_unit_price_in_cents
      if promo and price
        promo.discounted_price_in_cents(price)
      elsif price
        price.amount_in_cents
      end
    end
end
