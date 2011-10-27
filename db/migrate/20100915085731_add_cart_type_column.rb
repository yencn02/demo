class AddCartTypeColumn < ActiveRecord::Migration
  def self.up
    add_column :carts, :cart_type, :string
  end

  def self.down
    remove_column :carts, :cart_type
  end
end
