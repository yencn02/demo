class Admin::UsersController < Admin::BaseController
   
  active_scaffold :users do |config|
    config.columns = [:email, :password, :password_confirmation, :is_admin]

    config.columns[:password].form_ui = :password

    config.list.columns   = [:id, :email, :is_admin, :login_count, :current_login_ip]

    config.nested.add_link('User Account', [:account])
  end

end
