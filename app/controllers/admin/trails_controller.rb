class Admin::TrailsController < Admin::BaseController

  active_scaffold :trails do |config|
    config.columns = [:name, :video]
  end
end
