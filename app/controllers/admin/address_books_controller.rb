class Admin::AddressBooksController < ApplicationController
  layout 'admin'
  active_scaffold :address_book do |config|
    config.columns = [
      :first_name,
      :last_name,
      :address1,
      :address2,
      :city,
      :state,
      :zipcode,
      :country
    ]
  end
end
