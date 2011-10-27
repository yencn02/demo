class AddSessionIdToOrdersTable < ActiveRecord::Migration
  def self.up
    add_column :orders, :session_id, :string
  end

  def self.down
    remove_column :orders, :session_id
  end
end
