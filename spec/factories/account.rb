Factory.define :account do |a|
  a.first_name "AAA"
  a.last_name "BBB"
  a.address1 "123 ABC street"
  a.country "USA"
  a.city "New york"
  a.zipcode "12345"
  a.user { Factory(:user) }
end