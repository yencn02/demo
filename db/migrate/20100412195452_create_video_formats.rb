class CreateVideoFormats < ActiveRecord::Migration
  def self.up
    create_table :video_formats do |t|
      t.string :name
      t.string :sku
      t.text :details
      t.boolean :is_downloadable
      t.string :download_file_name
      t.string :download_content_type
      t.integer :download_file_size
      t.datetime :download_updated_at
      t.integer :video_id

      t.timestamps
    end
  end

  def self.down
    drop_table :video_formats
  end
end
