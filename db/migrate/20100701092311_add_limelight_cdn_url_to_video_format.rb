class AddLimelightCdnUrlToVideoFormat < ActiveRecord::Migration
  def self.up
    add_column :video_formats, :cdn_url, :string
  end

  def self.down
    remove_column :video_formats, :cdn_url
  end
end
