class CreateVideoPackVideos < ActiveRecord::Migration
  def self.up
    create_table :video_pack_videos, :id => false do |t|
      t.integer :video_pack_id, :video_id
    end
  end

  def self.down
    drop_table :video_packs
  end
end
