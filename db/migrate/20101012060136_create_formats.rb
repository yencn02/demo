class CreateFormats < ActiveRecord::Migration
  def self.up
    create_table :formats do |t|
      t.string :name
      t.timestamps
    end
    add_column :video_formats, :format_id, :integer
    remove_column :video_formats, :name
    add_column :video_pack_formats, :format_id, :integer
    remove_column :video_pack_formats, :name
    add_column :video_pack_formats, :acutrack_sku, :string
  end

  def self.down
    drop_table :formats
    remove_column :video_formats, :format_id
    add_column :video_formats, :name, :string
    remove_column :video_pack_formats, :format_id
    add_column :video_pack_formats, :name, :string
    remove_column :video_pack_formats, :acutrack_sku
  end
end
