class CreateTablesForShoppingCart < ActiveRecord::Migration
  def self.up
    create_table :carts do |t|
      t.integer :account_id
      t.string :session_id
      t.integer :billing_address_id
      t.timestamps
    end
    create_table :address_books do |t|
      t.integer :account_id
      t.string :nick_name
      t.string :first_name
      t.string :last_name
      t.string :address1
      t.string :address2
      t.string :email
      t.string :city
      t.string :state
      t.string :zipcode
      t.string :country
      t.string :phone
      t.timestamps
    end
    rename_column :line_items, :order_id, :cart_id
    add_column :line_items, :billing_later, :boolean, :default => false
    
    add_column :orders, :billing_address_id, :integer
    add_column :orders, :shipping_address_id, :integer
    add_column :orders, :credit_card_id, :integer
    add_column :orders, :status, :string

    create_table :ordered_line_items do |t|
      t.integer :order_id
      t.integer :product_id
      t.string :product_type
      t.integer :price
      t.string :promo_discount_type
      t.integer :promo_discount_amount_in_cents
      t.float :promo_discount_percentage
      t.integer :unit_price_in_cents
      t.string :product_title
      t.string :product_description
      t.string :currency
      t.integer :quantity
      t.timestamps
    end

    create_table :card_types do |t|
      t.string :name
      t.timestamps
    end
    create_table :credit_cards do |t|
      t.string :card_type_id
      t.string :holder_name
      t.string :card_name
      t.integer :expiration_month
      t.integer :expiration_year
      t.timestamps
    end
  end

  def self.down
    drop_table :carts
    drop_table :address_books
    rename_column :line_items, :cart_id, :order_id
    remove_column :line_items, :billing_later
    remove_column :orders, :billing_address_id
    remove_column :orders, :shipping_address_id
    remove_column :orders, :credit_card_id
    remove_column :orders, :status
    drop_table :ordered_line_items
    drop_table :credit_cards
    drop_table :card_types
  end
end
