Factory.sequence(:email) {|n| "test#{n}@test.com"}
Factory.define :user do |u|
  u.email { Factory.next :email }
  u.password "123456"
  u.password_confirmation { |w| w.password }
end