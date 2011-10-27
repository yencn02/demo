class CartAddShippingAddressIdColumn < ActiveRecord::Migration
  def self.up
    add_column :carts, :shipping_address_id, :integer
    add_column :carts, :credit_card_id, :integer
    rename_column :credit_cards, :card_name, :card_number
  end

  def self.down
    remove_column :carts, :shipping_address_id
    remove_column :carts, :credit_card_id
    rename_column :credit_cards, :card_number, :card_name
  end
end
