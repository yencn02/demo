Given /^the following users:$/ do |users|
  User.create!(users.hashes)
end

When /^I delete the (\d+)(?:st|nd|rd|th) user$/ do |pos|
  visit users_url
  within("table tr:nth-child(#{pos.to_i+1})") do
    click_link "Destroy"
  end
end

When /^I view all videos from page (.+)$/ do |page|  
  visit videos_path + "?page=#{page.gsub(/\"/,"").to_i}"
end

When /^I follow image link "([^"]*)"$/  do |img_alt|
  puts find(:xpath, img_alt)
end


Then /^I should see the following users:$/ do |expected_users_table|
  expected_users_table.diff!(tableish('table tr', 'td,th'))
end

# user login ---------------------------------------------------------
Given /^I already a user$/ do
  user = User.create(:email => 'test@vafitness.com', :password => 'test123', :password_confirmation => 'test123')
  Factory.create(:account, :first_name => 'Jimmy', :last_name => 'Tester', :user => user)
end
#end user login

# user admin login -----------------------------------------------------
Given /^I already a admin user and a regular user$/ do
  admin_user = User.create(:email => 'admin@vafitness.com', :password => 'test123', :password_confirmation => 'test123', :is_admin => 1)
  Factory.create(:account, :first_name => 'Jimmy', :last_name => 'Tester', :user => admin_user)

  regular_user = User.create(:email => 'test@vafitness.com', :password => 'test123', :password_confirmation => 'test123')
  Factory.create(:account, :first_name => 'Jimmy', :last_name => 'Tester', :user => regular_user)
end

# end user admin login -------------------------------------------------

Given /^I have the following the videos$/ do |table|
  table.hashes.each do |row|    
    video = Factory.create(:video, :title => row[:title])    
    sleep 1
    format = Factory.create(:format, :name => row[:format])
    price = Price.new(:amount_in_cents => (rand(10) + 1))
    video_format = Factory.create(:video_format, :format => format, :video => video, :price => price)
  end
end


Given /^I have the following the videos pack$/ do |table|
  table.hashes.each do |row|
    # video pack
    VideoPack.create(:title => row[:video_pack_name], :is_featured => row[:is_featured], :description => "Great #{row[:video_pack_name]}!", :image => '', :purchase_count => rand(1000), :published_at => rand(30).days.ago)
  end
end

Given /^I have the following the categories$/ do |table|
  table.hashes.each do |row|    
    @category = Category.create(:name => row[:name])
    unless row[:categorizable].blank?      
      @video = Video.create(:title => "title", :description => "description", :duration_in_seconds => 100)
      @category.categorizables.create(:categorized => @video)
    end
  end
end
  

Then /^I should see element "([^"]*)"$/ do |element|
  page.should have_css(element)
end

Then /^I should not see element "([^"]*)"$/ do |element|
  page.should_not have_css(element)
end