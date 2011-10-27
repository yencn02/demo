Given /^I already logged in successfully$/ do
  user = User.create(:email => 'test@vafitness.com', :password => 'test123', :password_confirmation => 'test123')
  @account = Factory.create(:account, :first_name => 'Jimmy', :last_name => 'Tester', :user => user)
  visit "/login"
  fill_in "user_session[email]", :with => user.email
  fill_in "user_session[password]", :with => user.password
  click_button "Sign In"
  URI.parse(current_url).path.should_not == "/session"
end

Then /^I should see below$/ do |table|
  table.hashes.each do |row|
    Then "I should see \"#{row[:text]}\""
  end
end

Then /^I should not see the below$/ do |table|
  table.hashes.each do |row|
    Then "I should not see \"#{row[:text]}\""
  end
end

Then /^the field "([^"]*)" should contain "([^"]*)"$/ do |field, value|
  if defined?(Spec::Rails::Matchers)
    find_field(field).value.should =~ /#{value}/
  else
    assert_match(/#{value}/, field_labeled(field).value)
  end
end