class CreateGymLocations < ActiveRecord::Migration
  def self.up
    create_table :gym_locations do |t|
      t.string :location_name
      t.string :phone
      t.string :website
      t.string :address1
      t.string :address2
      t.string :zipcode
      t.string :city
      t.string :state
      t.string :country
      t.timestamps
    end
  end

  def self.down
    drop_table :gym_locations
  end
end
