class CreateVideoPackFormats < ActiveRecord::Migration
  def self.up
    create_table :video_pack_formats do |t|
      t.string :name
      t.string :sku
      t.text :details
      t.integer :video_pack_id
      t.timestamps
    end
  end

  def self.down
    drop_table :video_pack_formats
  end
end
