class Price < ActiveRecord::Base
  composed_of :amount, :class_name => 'Money', :mapping => [%w(amount_in_cents cents), %w(currency currency)]

  validates_presence_of :amount_in_cents
  belongs_to :product, :polymorphic => true

  def to_label
    "#{amount_in_cents}"
  end
end
