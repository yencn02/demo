class RemoveCreditCard < ActiveRecord::Migration
  def self.up
    drop_table :credit_cards
    remove_column :address_books, :email
    remove_column :address_books, :phone
    add_column :accounts, :reuse_for_purchase, :boolean, :default => true
    create_table :anonymous_users do |t|
      t.string :email
      t.string :first_name
      t.string :last_name
      t.string :business_name
      t.string :address1
      t.string :address2
      t.string :city
      t.string :state
      t.string :zipcode
      t.string :country
      t.timestamps
    end
    remove_column :carts, :account_id
    add_column :carts, :buyer_id, :integer
    add_column :carts, :buyer_type, :string
    remove_column :address_books, :account_id
    add_column :address_books, :buyer_id, :integer
    add_column :address_books, :buyer_type, :string
    remove_column :orders, :account_id
    add_column :orders, :buyer_id, :integer
    add_column :orders, :buyer_type, :string
    remove_column :orders, :credit_card_id
    remove_column :carts, :credit_card_id
  end

  def self.down
    create_table :credit_cards do |t|
      t.string :card_type_id
      t.string :holder_name
      t.string :card_name
      t.integer :expiration_month
      t.integer :expiration_year
      t.timestamps
    end
    add_column :address_books, :email, :string
    add_column :address_books, :phone, :string
    remove_column :accounts, :reuse_for_purchase
    drop_table :anonymous_users
    add_column :carts, :account_id, :integer
    remove_column :carts, :buyer_id
    remove_column :carts, :buyer_type
    add_column :address_books, :account_id, :integer
    remove_column :address_books, :buyer_id
    remove_column :address_books, :buyer_type
    add_column :orders, :account_id, :integer
    remove_column :orders, :buyer_id
    remove_column :orders, :buyer_type
    add_column :orders, :credit_card_id, :integer
    add_column :carts, :credit_card_id, :integer
  end
end
