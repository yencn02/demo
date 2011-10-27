class CreateVideoStats < ActiveRecord::Migration
  def self.up
    create_table :video_stats do |t|
      t.integer :video_id
      t.integer :user_id
      t.string :ip_address

      t.timestamps
    end
  end

  def self.down
    drop_table :video_stats
  end
end
