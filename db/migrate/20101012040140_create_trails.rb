class CreateTrails < ActiveRecord::Migration
  def self.up
    create_table :trails do |t|
      t.string :name
      t.integer :video_id
      t.timestamps
    end
  end

  def self.down
    drop_table :trails
  end
end
