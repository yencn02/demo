class CreateOrders < ActiveRecord::Migration
  def self.up
    create_table :orders do |t|
      t.integer :account_id
      t.integer :total_amount_in_cents
      t.string :currency

      t.timestamps
    end
  end

  def self.down
    drop_table :orders
  end
end
