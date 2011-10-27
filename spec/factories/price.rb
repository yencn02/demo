Factory.define :price do |p|
  p.product {Factory(:video_format)}
  p.amount_in_cents rand(100)
end