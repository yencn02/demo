class CreateLineItems < ActiveRecord::Migration
  def self.up
    create_table :line_items do |t|
      t.integer :order_id
      t.integer :product_id
      t.string :product_type
      t.integer :price_id
      t.integer :promo_id
      t.integer :unit_price_in_cents
      t.string :currency
      t.integer :quantity

      t.timestamps
    end
  end

  def self.down
    drop_table :line_items
  end
end
