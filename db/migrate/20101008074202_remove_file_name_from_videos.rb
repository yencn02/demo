class RemoveFileNameFromVideos < ActiveRecord::Migration
  def self.up
    begin
      remove_column :videos, :file_name
    rescue Exception => @err
      puts "Error: #{@err.message}"
    end
  end

  def self.down
    begin
      add_column :videos, :file_name, :string
    rescue Exception => @err
      puts "Error: #{@err.message}"
    end
  end
end
