class AddAcutrackSku < ActiveRecord::Migration
  def self.up
    add_column :video_formats, :acutrack_sku, :string
  end

  def self.down
    remove_column :video_formats, :acutrack_sku
  end
end
