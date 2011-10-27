class AddGeokitColumns < ActiveRecord::Migration
  def self.up
    add_column :gym_locations, :distance, :integer
    add_column :gym_locations, :lat, :float
    add_column :gym_locations, :lng, :float
  end

  def self.down
    remove_column :gym_locations, :distance
    remove_column :gym_locations, :lat
    remove_column :gym_locations, :lng
  end
end
