class UpdateVideoPackFormat < ActiveRecord::Migration
  def self.up
    remove_column :video_pack_formats, :acutrack_sku
    add_column :video_pack_formats, :is_downloadable, :boolean
  end

  def self.down
    add_column :video_pack_formats, :acutrack_sku, :string
    remove_column :video_pack_formats, :is_downloadable
  end
end
