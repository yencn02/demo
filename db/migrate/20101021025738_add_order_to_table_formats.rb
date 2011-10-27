class AddOrderToTableFormats < ActiveRecord::Migration
  def self.up
    add_column :formats, :format_order, :integer
  end

  def self.down
    remove_column :formats, :format_order
  end
end
