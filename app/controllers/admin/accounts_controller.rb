class Admin::AccountsController < ApplicationController
  layout 'admin'
  active_scaffold :account do |config|
    config.columns = [
      :first_name,
      :last_name,
      :business_name,
      :address1,
      :address2,
      :city,
      :state,
      :zipcode,
      :country
    ]
  end
end
