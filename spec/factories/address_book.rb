Factory.sequence(:last_name) {|n| "Last name #{n}"}
Factory.sequence(:first_name) {|n| "First name #{n}"}

Factory.define :address_book do |address|
  address.last_name { Factory.next :last_name }
  address.first_name { Factory.next :first_name }
  address.address1 "my string"
  address.city "my string"
  address.state "state"
  address.country "country"
  address.phone "phone"
  address.zipcode "12345"
  address.account { Factory(:account) }
end