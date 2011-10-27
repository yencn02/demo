require 'spec_helper'

describe CreditCard do

  describe "Instance Methods" do

    before :each do
      @credit_card = CreditCard.new(
        :last_name => "Lui", :first_name => "John", :expiration_month => 1,
        :expiration_year => Time.now.year + 1, :card_number => "4242424242424242"
      )
      card_type = mock_model(CardType, :code => "visa")
      @credit_card.stub(:card_type).and_return card_type
    end

    describe "#validate" do

      before :each do
        @am_credit_card = mock("ActiveMerchant::Billing::CreditCard")
        ActiveMerchant::Billing::CreditCard.should_receive(:new).with(
          :first_name => @credit_card.first_name,
          :last_name  => @credit_card.last_name,
          :month      => @credit_card.expiration_month,
          :year       => @credit_card.expiration_year,
          :type       => @credit_card.card_type.code,
          :number     => @credit_card.card_number
        ).and_return @am_credit_card
      end
      
      it "should be valid" do
        @am_credit_card.should_receive(:valid?).and_return true
        @am_credit_card.should_not_receive(:errors)
        @credit_card.validate
      end

      it "should be invalid" do
        @am_credit_card.should_receive(:valid?).and_return false

        full_messages = []
        (rand(10) + 1).times do
          full_messages << mock("A message")
        end
        errors = mock("List of errors", :full_messages => full_messages)

        @am_credit_card.should_receive(:errors).and_return errors

        full_messages.each do |msg|
          cr_errors = mock("Credit card's errors")
          @credit_card.should_receive(:errors).and_return cr_errors
          cr_errors.should_receive(:add_to_base).with(msg)
        end

        @credit_card.validate
      end

    end
  end# End Instance Methods

  describe "Class Methods" do

    describe "#find_or_new" do

      it "should return an existing card" do
        args = {"some" => "thing"}

        card = mock_model(CreditCard)
        CreditCard.should_receive(:find).with(:first, :conditions => args).and_return card

        CreditCard.find_or_new(args).should == card
      end

      it "should return a new card" do
        args = {"some" => "thing"}

        CreditCard.should_receive(:find).with(:first, :conditions => args).and_return nil
        card = mock_model(CreditCard)
        CreditCard.should_receive(:new).with(args).and_return card

        CreditCard.find_or_new(args).should == card
      end

    end

  end# End Class Methods

end#End describe CreditCard