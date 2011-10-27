module UsersHelper

  def address_to_js(address)
    javascript_tag("var billing_address = #{address.to_json}")
  end

  def address_books_to_js(address_books)
    javascript_tag("var addressBooks = #{address_books.to_json}")
  end
end
