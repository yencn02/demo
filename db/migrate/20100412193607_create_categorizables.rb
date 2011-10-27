class CreateCategorizables < ActiveRecord::Migration
  def self.up
    create_table :categorizables do |t|
      t.integer :category_id
      t.string :categorized_type
      t.integer :categorized_id

      t.timestamps
    end
  end

  def self.down
    drop_table :categorizables
  end
end
