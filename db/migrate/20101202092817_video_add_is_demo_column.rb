class VideoAddIsDemoColumn < ActiveRecord::Migration
  def self.up
    add_column :videos, :is_demo, :boolean, :default => false
    Video.update_all("is_demo = 1", "featured_home = 1")
  end

  def self.down
    remove_column :videos, :is_demo
  end
end
