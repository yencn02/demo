Factory.define :cart do |u|
  u.cart_type Cart::ACCOUNT_TYPE
  u.account { Factory(:account) }
end