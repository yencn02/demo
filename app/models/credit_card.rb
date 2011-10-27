class Class
  def my_attr_accessor(*accessors)
   accessors.each do |m|
      define_method(m) do
        instance_variable_get("@#{m}")
      end

      define_method("#{m}=") do |val|
        instance_variable_set("@#{m}",val)
      end
    end
  end
end

class CreditCard
  my_attr_accessor :first_name, :last_name, :expiration_month, :expiration_year, :card_type, :card_number
  def initialize(args)
    @first_name = args[:first_name]
    @last_name = args[:last_name]
    @expiration_month = args[:expiration_month]
    @expiration_year = args[:expiration_year]
    @card_type = CardType.find(args[:card_type_id])
    
    @card_number = args[:card_number]
  end

  def validate
    creditcard  = ActiveMerchant::Billing::CreditCard.new(
      :first_name => self.first_name,
      :last_name  => self.last_name,
      :month      => self.expiration_month,
      :year       => self.expiration_year,
      :type       => self.card_type.code,
      :number     => self.card_number
    )
    creditcard.valid?
    return creditcard
  end
end