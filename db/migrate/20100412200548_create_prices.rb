class CreatePrices < ActiveRecord::Migration
  def self.up
    create_table :prices do |t|
      t.integer :amount_in_cents
      t.string :currency
      t.string :product_type
      t.integer :product_id

      t.timestamps
    end
  end

  def self.down
    drop_table :prices
  end
end
