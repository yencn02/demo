class CreateVideos < ActiveRecord::Migration
  def self.up
    create_table :videos do |t|
      t.string :title
      t.string :slug
      t.text :description
      t.date :published_at
      t.string :image_file_name
      t.string :image_content_type
      t.integer :image_file_size
      t.datetime :image_updated_at
      t.integer :duration_in_seconds, :default => 0
      t.integer :view_count, :default => 0
      t.integer :purchase_count, :default => 0
      t.boolean :is_featured, :default => false

      t.timestamps
    end
  end

  def self.down
    drop_table :videos
  end
end
