class UpdateTablesForSupportAcutrack < ActiveRecord::Migration
  def self.up
    add_column :orders, :order_number, :string
    add_column :orders, :approval_code, :string
    add_column :orders, :tracking_number, :string
  end

  def self.down
    remove_column :orders, :order_number
    remove_column :orders, :approval_code
    remove_column :orders, :tracking_number
  end
end
