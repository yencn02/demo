module NavigationHelpers
  # Maps a name to a path. Used by the
  #
  #   When /^I go to (.+)$/ do |page_name|
  #
  # step definition in web_steps.rb
  #
  def path_to(page_name)
    case page_name
    
    when /the home\s?page/
      '/'
    when /the new user page/
      new_user_path
    when /the view shopping cart/
      cart_account_path
    when /shipping address/
      shipping_address_account_path
    when /billing address/
      billing_address_account_path
    when /confirm order/
      confirm_order_account_path
    when /account/
      account_url
    when /user registration/
      new_user_path
    when /login/
      login_path
    when /user information/
      information_account_path    
    when /user admin/
      admin_users_path
    when /video admin/
      admin_videos_path
    when /video formats admin/
      admin_video_formats_path
    when /video packs admin/
      admin_video_packs_path
    when /video pack formats admin/
      admin_video_pack_formats_path
    when /gym locations admin/
      admin_gym_locations_path
    when /promos admin/
      admin_promos_path
    when /orders admin/
      admin_orders_path
    when /admin/
      "/admin"
    when /video/
      videos_path    
    when /new session/
      new_session_path
    when /logout/
      logout_path
    # Add more mappings here.
    # Here is an example that pulls values out of the Regexp:
    #
    #   when /^(.*)'s profile page$/i
    #     user_profile_path(User.find_by_login($1))

    else
      raise "Can't find mapping from \"#{page_name}\" to a path.\n" +
        "Now, go and add a mapping in #{__FILE__}"
    end
  end
end

World(NavigationHelpers)
