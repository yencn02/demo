class AddFeaturedHomeToVideosTable < ActiveRecord::Migration
  def self.up
    add_column :videos, :featured_home, :boolean
  end

  def self.down
    remove_column :videos, :featured_home
  end
end
