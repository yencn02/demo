class AnonymousUser < ActiveRecord::Base

  validates_presence_of :email
  has_many :address_books,
           :order => "updated_at DESC",
           :limit => 2,
           :conditions => {:in_use => false},
           :as => :buyer
  has_many :orders, :as => :buyer
  validates_as_email :email, :if => Proc.new { |u| !u.email.blank?}
  def to_label
    "#{last_name}, #{first_name}"
  end
  class << self

    def find_or_new(args)
      user = find_by_email(args[:email])
      if user
        user.update_attributes(args)
      else
        user = self.new(args)
      end
      return user
    end

  end

end
