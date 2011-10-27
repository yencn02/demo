class Promo < ActiveRecord::Base
  @@discount_types = %w(amount percentage)
  cattr_reader :discount_types

  composed_of :discount_amount, :class_name => 'Money', :mapping => [%w(discount_amount_in_cents cents), %w(currency currency)]

  validates_presence_of :product_type, :name, :discount_type
  validates_inclusion_of :discount_type, :in => @@discount_types
  validates_presence_of :discount_amount, :if => proc { |promo| promo.discount_type == 'amount' }
  validates_presence_of :discount_percentage, :if => proc { |promo| promo.discount_type == 'percentage' }

  belongs_to :product, :polymorphic => true

  def discounted_price_in_cents(price)
    case discount_type
    when 'amount'
      price.amount_in_cents - discount_amount_in_cents
    when 'percentage'
      (price.amount_in_cents.to_f * discount_percentage) / 100.0
    end
  end

  def discounted_price(price)
    Money.new(discounted_price_in_cents(price))
  end
end
