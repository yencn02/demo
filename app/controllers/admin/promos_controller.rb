class Admin::PromosController < Admin::BaseController
  
  active_scaffold :promos do |config|
    config.columns = [
      :name,
      :product_type,
      :discount_type,
      :discount_amount_in_cents,
      :discount_percentage,
    ]

    config.columns[:discount_type].form_ui = :select
    config.columns[:discount_type].options = {
      :options => Promo.discount_types.collect { |dt| [dt.titlecase, dt] }
    }

    config.columns[:product_type].form_ui = :select
    config.columns[:product_type].options = {
      :options => [['Video', 'Video'], ['Video Pack', 'VideoPack']]
    }
  end
end
