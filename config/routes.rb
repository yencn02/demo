ActionController::Routing::Routes.draw do |map|
  map.namespace :admin do |admin|
    admin.root :controller => 'base', :action => 'dashboard'

    admin.resources :accounts, :active_scaffold => true
    admin.resources :line_items, :active_scaffold => true
    admin.resources :orders, :active_scaffold => true
    admin.resources :ordered_line_items, :active_scaffold => true
    admin.resources :users, :active_scaffold => true
    admin.resources :prices, :active_scaffold => true
    admin.resources :formats, :active_scaffold => true
    admin.resources :promos, :active_scaffold => true
    admin.resources :videos, :active_scaffold => true
    admin.resources :trails, :active_scaffold => true
    admin.resources :video_formats, :active_scaffold => true
    admin.resources :video_pack_formats, :active_scaffold => true
    admin.resources :video_packs, :active_scaffold => true
    admin.resources :gym_locations, :active_scaffold => true
    admin.resources :images, :collection => { :upload_image => :post }
  end

  map.resource :account, :controller => 'users', :member => {
    :billing_address      => :get,
    :cart                 => :get,
    :confirm_order        => :get,
    :forgot_password      => :get,
    :information          => :get,
    :purchases            => :get,
    :remove_address       => :get,
#    :saved_items          => :get,
    :settings             => :get,
    :shipping_address     => :get,
    :login_no_download    => :get
  }

  map.resource :payments

  map.resource :cart, :controller => 'cart', :member => {
    :add_item           => :any,
    :update_items       => :post,
    :remove_item        => :any,
    :save_for_later     => :any,
    :move_to_cart       => :any,
    :set_shipping_info  => :any,
    :set_billing_info   => :post,
    :checkout           => :post
  }

  map.resource :session, :controller => 'user_sessions', :member => {
    :ajax_create => :post
  }

  map.resources :orders, :collection => {
    :create_order                   => :get,
    :receive_shipping_confirmation  => :post,
    :test_shipping_confirm          => :get
  }

  map.resources :pages, :collection => {
    :about          => :get,
    :contact        => :get,
    :facility       => :get,
    :purchase_info  => :get,
    :howto          => :get,
    :playlist       => :get
  }
  
  map.resources :locations, :collection => {
    :search => :any,
    :point_direction => :get,
    :line_direction => :get,
  }
  
  map.resources :users
  map.resources :videos
  map.resources :video_packs, :collection => {
    :index_obsolete   => :get,
    :playlist         => :get,
  }

  map.resources :orders

  map.resources :password_resets, :only => [ :new, :create, :edit, :update ]
  map.search    'search',     :controller => 'videos',            :action => 'index'
  map.login     'login',      :controller => 'user_sessions',     :action => 'new'
  map.logout    'logout',     :controller => 'user_sessions',     :action => 'destroy'
  map.page      ':page',      :controller => 'pages',             :action => 'show'

  map.root :controller => 'pages', :action => 'show', :page => nil
end
