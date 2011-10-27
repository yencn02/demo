class AddInUseColumnToAddressBook < ActiveRecord::Migration
  def self.up
    add_column :address_books, :in_use, :boolean, :default => false
  end

  def self.down
    remove_column :address_books, :in_use
  end
end
