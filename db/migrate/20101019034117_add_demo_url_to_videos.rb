class AddDemoUrlToVideos < ActiveRecord::Migration
  def self.up
    add_column :videos, :demo_url, :string
  end

  def self.down
    remove_column :videos, :demo_url
  end
end
