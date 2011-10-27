class CreateVideoPacks < ActiveRecord::Migration
  def self.up
    create_table :video_packs do |t|
      t.string :title
      t.string :slug
      t.text :description
      t.date :published_at
      t.string :image_file_name
      t.string :image_content_type
      t.integer :image_file_size
      t.datetime :image_updated_at
      t.integer :purchase_count, :default => 0
      t.boolean :is_featured, :default => false

      t.timestamps
    end
  end

  def self.down
    drop_table :video_packs
  end
end
