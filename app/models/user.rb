class User < ActiveRecord::Base
  # Authlogic authentication
  acts_as_authentic do |c|
    # Add specific configuration settings here
  end

  has_one :account

  accepts_nested_attributes_for :account
  before_save :validate_account

  def to_label
    "User (#{id})"
  end

  def self.is_admin(user)
    self.find_by_email(user.email).is_admin
  end

  def deliver_password_reset_instructions!
    reset_perishable_token!
    Mailer.deliver_password_reset_instructions(self)
  end

  def validate_account
    unless self.account
      self.account = Account.new
    end
  end
end
