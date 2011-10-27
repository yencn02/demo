class CreatePromos < ActiveRecord::Migration
  def self.up
    create_table :promos do |t|
      t.string :name
      t.string :discount_type
      t.integer :discount_amount_in_cents
      t.string :currency
      t.float :discount_percentage
      t.string :product_type
      t.integer :product_id

      t.timestamps
    end
  end

  def self.down
    drop_table :promos
  end
end
