class CreditCardSplitFullName < ActiveRecord::Migration
  def self.up
    rename_column :credit_cards, :holder_name, :first_name
    add_column :credit_cards, :last_name, :string
    add_column :card_types, :code, :string
  end

  def self.down
    rename_column :credit_cards, :first_name, :holder_name
    remove_column :credit_cards, :last_name
    remove_column :card_types, :code
  end
end
