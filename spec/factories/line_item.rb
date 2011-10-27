Factory.define :line_item do |u|
  u.unit_price_in_cents rand(100)
  u.quantity rand(10)
  u.product {Factory(:video_format)}
  u.price { Factory(:price) }
  u.cart { Factory(:cart) }
end