class Category < ActiveRecord::Base
  slugify :name

  validates_presence_of :name, :slug

  has_many :categorizables

  def self.feature_category
    categorizables = Categorizable.find(:all, :select => "distinct category_id")
    category_ids = categorizables.collect { |categorizable| categorizable.category_id }
    self.find(:all, :conditions =>  [ "id in (?)", category_ids ])
  end
  
end
