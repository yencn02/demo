class Admin::BaseController < ApplicationController
  layout 'admin'
  before_filter :require_admin
  
  ActiveScaffold.set_defaults do |config| 
    config.ignore_columns.add [:created_at, :updated_at]
  end

  def authorized
  end

  def dashboard
    
  end
  
end