Factory.define :credit_card do |a|
  a.first_name "AAA"
  a.last_name "BBB"
  a.card_number "4242424242424242"
  a.expiration_month 12
  a.expiration_year {Time.now.year + 10}
  a.card_type { Factory(:card_type, :code => "visa") }
end