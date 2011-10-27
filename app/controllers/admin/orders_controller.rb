class Admin::OrdersController < Admin::BaseController
  
  active_scaffold :orders do |config|
    config.columns = [:approval_code, :created_at, :buyer, :tracking_number, :total_amount_in_cents, :ordered_line_items, :billing_address, :shipping_address]
    config.list.columns = [:approval_code, :created_at, :buyer, :buyer_email, :tracking_number, :total_amount_in_cents, :ordered_line_items, :billing_address, :shipping_address]
    config.show.columns = [:approval_code, :created_at, :buyer, :buyer_email, :tracking_number, :total_amount_in_cents, :ordered_line_items, :billing_address, :shipping_address]
    config.columns[:approval_code].label = 'Order number'
    config.columns[:total_amount_in_cents].options = {:format => :number_to_currency}
    config.columns[:created_at].label = 'Order date'
  end
end
