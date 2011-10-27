class AddressBook < ActiveRecord::Base
  COUNTRY_REQUIRED_STATES = Carmen::STATES.map{|x| x[0]}
  ADDRESSES_PER_ACCOUNT = 2
  belongs_to :buyer, :polymorphic => true
  validates_presence_of :first_name, :last_name, :address1, :city, :country, :zipcode
  validates_format_of :zipcode,
                      :with => /^\d{5}((-)?\d{4})?|([A-Za-z]\d[A-Za-z]([- ])?\d[A-Za-z]\d)/,
                      :message => "correct format For US 5 digits like 85123, for Canada a format like R2G 1T9"
  validates_format_of_zipcode :zipcode
  validates_presence_of :state, :if => Proc.new { |address| COUNTRY_REQUIRED_STATES.index(address.country) }

  def to_order
    address = self.clone
    address.in_use = true
    address.save
    address
  end

  def to_label
    "#{first_name} #{last_name}, #{address1}, #{city}, #{state} #{zipcode}, #{country}"
  end

  def to_hash
    {
      "FirstName" => first_name,
      "LastName" => last_name,
      "OrderShippingAddress" => {
        "Address" => address1,
        "Address2" => address2,
        "City" => city,
        "StateCode" => state,
        "CountryCode" => country,
        "StateName" => Carmen::state_name(state) ,
        "CountryName" => Carmen::country_name(country),
        "PostalCode" => zipcode
      },
      "ProductShippingTypeID" => shipping_type_id
    }
  end

  def shipping_type_id
    country == "US" ? DOMESTIC_SHIPPING : INTERNATIONAL_SHIPPING
  end

  class << self
    def new_based_on_account(user)
      if user && user.account
        address_book = AddressBook.new(user.account.to_hash)
      else
        address_book = AddressBook.new
      end
      return address_book
    end
    def find_or_new(args, buyer)
      id = args["id"]
      args[:in_use] = false
      args.delete_if{|k,v| k == "id"}
      if id && !id.blank?
        address = self.find(id)
        address.update_attributes(args)
      else
        args[:buyer_id] = buyer.id
        args[:buyer_type] = buyer.class.name
        address = self.find(:first, :conditions => args)
        
        address = self.new(args) unless address
      end
      return address
    end
    
  end
end
