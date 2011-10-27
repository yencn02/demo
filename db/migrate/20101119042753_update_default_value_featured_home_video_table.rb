class UpdateDefaultValueFeaturedHomeVideoTable < ActiveRecord::Migration
  def self.up
    remove_column :videos, :featured_home
    add_column :videos, :featured_home, :boolean, :default => false
  end

  def self.down
    remove_column :videos, :featured_home
    add_column :videos, :featured_home, :boolean
  end
end
