class AddFileNameToVideos < ActiveRecord::Migration
 def self.up
    add_column :videos, :file_name, :string
  end

  def self.down
    remove_column :videos, :file_name
  end
end
