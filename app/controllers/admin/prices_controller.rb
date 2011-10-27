class Admin::PricesController < Admin::BaseController
 
  active_scaffold :prices do |config|
    config.columns = [:product, :amount_in_cents]
  end
end
