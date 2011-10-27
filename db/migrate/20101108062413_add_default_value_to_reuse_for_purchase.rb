class AddDefaultValueToReuseForPurchase < ActiveRecord::Migration
  def self.up
    remove_column :accounts, :reuse_for_purchase
    add_column :accounts, :reuse_for_purchase, :boolean, :default => false
  end

  def self.down
    remove_column :accounts, :reuse_for_purchase
    add_column :accounts, :reuse_for_purchase, :boolean, :default => true
  end
end
