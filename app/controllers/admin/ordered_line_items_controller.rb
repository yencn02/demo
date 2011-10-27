class Admin::OrderedLineItemsController < ApplicationController
  layout 'admin'
  active_scaffold :ordered_line_items do |config|
    config.columns = [:product, :unit_price_in_cents, :quantity, :price, :videos]
    config.update.columns = [:unit_price_in_cents, :quantity, :price]
    config.columns[:videos].label = "Videos in pack"
    config.columns[:price].label = "Subtotal in cents"
  end
end
