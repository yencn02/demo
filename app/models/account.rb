class Account < ActiveRecord::Base

  belongs_to :user
  has_many :address_books, 
           :order => "updated_at DESC",
           :limit => 2,
           :conditions => {:in_use => false},
           :as => :buyer
  has_one :cart, :as => :buyer
  has_many :orders, :as => :buyer

  #validates_presence_of :user
  validates_presence_of :first_name, :last_name, :address1, :country, :city, :zipcode
  validates_uniqueness_of :user_id
  validates_format_of :zipcode,
                      :with => /^\d{5}((-)?\d{4})?|([A-Za-z]\d[A-Za-z]([- ])?\d[A-Za-z]\d)/,
                      :message => "correct format For US 5 digits like 85123, for Canada a format like R2G 1T9"
  validates_format_of_zipcode :zipcode

  def to_label
    "#{last_name}, #{first_name}"
  end

  def to_hash
    hash = {}
    columns = [:first_name, :last_name, :address1, :address2, :country, :city, :zipcode, :state]
    columns.each do |column|
      hash[column] = self[column.to_s]
    end
    return hash
  end
end
