class Categorizable < ActiveRecord::Base
  validates_presence_of :category, :categorized
  validates_uniqueness_of :category_id, :scope => [:categorized_type, :categorized_id]

  belongs_to :category
  belongs_to :categorized, :polymorphic => true
end
