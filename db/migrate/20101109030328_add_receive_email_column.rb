class AddReceiveEmailColumn < ActiveRecord::Migration
  def self.up
    remove_column :accounts, :reuse_for_purchase
    add_column :accounts, :receive_email, :boolean, :default => false
  end

  def self.down
    remove_column :accounts, :receive_email
    add_column :accounts, :reuse_for_purchase, :boolean, :default => true
  end
end

