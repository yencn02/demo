Given /^I already have some seed data \#See RAILS_ROOT\/db\/seeds\.rb$/ do
  load "#{RAILS_ROOT}/db/seeds.rb"
end

When /^I'm on the view video page of "([^"]*)"$/ do |video_title|
  @video = Video.find_by_title(video_title)
end

When /^I choose the "([^"]*)" format$/ do |format_name|
  format = @video.formats.first(:include => :format, :conditions => {"formats.name" => format_name})
  visit add_item_cart_path(:price_id => format.price.id)
  @cart = Cart.get_cart(Cart::SESSION_TYPE, "xxxxx") if @cart.nil?
  @cart = Cart.get_cart(Cart::ACCOUNT_TYPE, @account.id) if @account
  @cart.add_or_update(format.price.id, 1)
end

When /^I'm on the view shopping cart page$/ do
  visit cart_account_path
end
Then /^I change the quantity of "([^"]*)" with format "([^"]*)" up to "([^"]*)"$/ do |title, format, value|
  video = Video.find_by_title(title)
  format = video.formats.first(:include => :format, :conditions => {"formats.name" => format})
  fill_in("cart[#{format.price.id}]", :with => value)
  @cart = Cart.get_cart(Cart::SESSION_TYPE, "xxxxx") if @cart.nil?
  @cart = Cart.get_cart(Cart::ACCOUNT_TYPE, @account.id) if @account
  @cart.add_or_update(format.price.id, value.to_i)
end

Then /^I should see the new value of subtotal$/ do
  if defined?(Spec::Rails::Matchers)
    page.should have_content("#{@cart.total.format}")
  else
    assert page.has_content?("#{@cart.total.format}")   
  end
end

Given /^I delete item of "([^"]*)" with format "([^"]*)" out of shopping cart$/ do |title, format|
  video = Video.find_by_title(title)
  format = video.formats.first(:include => :format, :conditions => {"formats.name" => format})
  within("div#item_#{format.price.id}") {
    click_link("Remove")
  }
end

Then /^I set status of "([^"]*)" with format "([^"]*)" to be "([^"]*)"$/ do |title, format, status|
  video = Video.find_by_title(title)
  format = video.formats.first(:include => :format, :conditions => {"formats.name" => format})
  within("div#item_#{format.price.id}") {
    click_link(status)
  }
end

Given /^I have some addresses in my address books$/ do |table|
  table.hashes.each do |address|
    Factory.create(:address_book, :account => @account,
      :last_name => address[:last_name], :first_name => address[:first_name],
      :address1 => address[:address1],:email => address[:email])
  end
end
Given /^I have the following videos$/ do |table|
  table.hashes.each do |row|
    video = Factory.create(:video, :title => row[:title], :description => (row[:description] || row[:title]))
    format = Factory.create(:format, :name => (row[:format] || "DVD"))
    price = Price.new(:amount_in_cents => (rand(10) + 1))
    video_format = Factory.create(:video_format, :format => format, :video => video, :price => price)
  end
end

Given /^I have some items in shopping cart$/ do |table|
  @cart = Cart.get_cart(Cart::SESSION_TYPE, "xxxxx") if @cart.nil?
  @cart = Cart.get_cart(Cart::ACCOUNT_TYPE, @account.id) if @account
  table.hashes.each do |row|
    video = Video.find_by_title(row[:title])
    format = video.formats.first(:include => :format, :conditions => {"formats.name" => row[:format]})
    @cart.add_or_update(format.price.id, 1)
  end
end

Then /^I should see my address books$/ do |table|
  table.hashes.each do |row|
    row.each do |k,v|
      Then "I should see \"#{row[k]}\""
    end
  end
end

Then /^I select shipping to address of "([^"]*)"$/ do |address1|
  address = AddressBook.find_by_address1(address1)
  Then "I press \"Ship to this Address\" within \"div#address_#{address.id}\""
end

Then /^I delete address "([^"]*)"$/ do |address1|
  address = AddressBook.find_by_address1(address1)
  Then "I press \"Delete\" within \"div#address_#{address.id}\""
end

Then /^I wait for response$/ do
  sleep 2
end

Then /^I wait for response about "([^"]*)" seconds$/ do |number|
  sleep number.to_i
end

Given /^I have the following card types$/ do |table|
  table.hashes.each do |row|
    CardType.create(:name => row[:name], :code => row[:code])
  end
end
Given /^I already set shipping address of cart to "([^"]*)"$/ do |address|
  address = AddressBook.find_by_address1(address)
  @account.cart.shipping_address = address
  @account.cart.save
end

Then /^I select a year from "([^"]*)"$/ do |selector|
  select("#{Time.now.year + 2}", :from => selector)
end

Given /^I already set billing address of cart to "([^"]*)"$/ do |address|
  address = AddressBook.find_by_address1(address)
  @account.cart.billing_address = address
  @account.cart.save
end

Given /^I already set credit card info as below$/ do |table|
  hash = {}
  table.rows_hash.each do |name, value|
    hash[name] = value
  end
  credit_card = Factory.create(:credit_card, hash)
  @account.cart.credit_card = credit_card
  @account.cart.save
end

Then /^I should see the following item info in card$/ do |table|
  table.hashes.each do |row|
    Then "I should see \"#{row[:text]}\""
  end
end

Then /^I should see shipping address$/ do |table|
  table.hashes.each do |row|
    Then "I should see \"#{row[:text]}\""
  end
end

Then /^I should see billing address$/ do |table|
  table.hashes.each do |row|
    Then "I should see \"#{row[:text]}\""
  end
end

Then /^I should see credit card info$/ do |table|
  table.hashes.each do |row|
    Then "I should see \"#{row[:text]}\""
  end
end
When /^I edit address of "([^"]*)"$/ do |address1|
  address = AddressBook.find_by_address1(address1)
  Then "I press \"Edit\" within \"div#address_#{address.id}\""
end