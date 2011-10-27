class Admin::FormatsController < Admin::BaseController

  active_scaffold :formats do |config|    
    config.columns = [:name, :format_order]
    config.list.sorting = {:format_order => 'ASC'}
  end
end
