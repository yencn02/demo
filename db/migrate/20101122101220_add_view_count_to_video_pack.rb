class AddViewCountToVideoPack < ActiveRecord::Migration
  def self.up
    add_column :video_packs, :view_count, :integer, :default => 0
  end

  def self.down
    remove_column :video_packs, :view_count
  end
end
