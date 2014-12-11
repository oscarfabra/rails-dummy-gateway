class Payment < ActiveRecord::Base
  belongs_to :order

  validates :number, :month, :year, :first_name, :last_name,
            :verification_value, presence: true

  # Processes this payment. Returns true or false depending on result.
  def process(amount)
    random_number = 1 + rand(10) # Generates a random number between 1 and 10
    return false if random_number == 1  # Rejects if random_number is 1 (10% of the time)

    # Use the TrustCommerce test servers
    ActiveMerchant::Billing::Base.mode = :test

    gateway = ActiveMerchant::Billing::TrustCommerceGateway.new(
        :login => 'TestMerchant',
        :password => 'password')

    # ActiveMerchant accepts all amounts as Integer values in cents
    amount = amount * 10

    # Processes payment with ActiveMerchant.
    credit_card = ActiveMerchant::Billing::CreditCard.new(
        number: @number,
        month: @month,
        year: @year,
        first_name: @first_name,
        last_name: @last_name,
        verification_value: @verification_value
    )

    # Validating the card automatically detects the card type
    result = false
    if credit_card.validate.empty?
      # Capture amount from the credit card
      response = gateway.purchase(amount, credit_card)

      if response.success?
        logger.info "Successfully charged $#{sprintf("%.2f", amount / 100)} to credit card #{credit_card.display_number}"
        result = true
      else
        logger.info "Unsuccessful charge of $#{sprintf("%.2f", amount / 100)} to credit card #{credit_card.display_number}"
        result = false
      end
    end
    @status = (result)? 1 : 9  # Updates status to 1 (success) or 9 (failed) accordingly
    save!  # Updates this payment in db.
    return true  # Returns true, for testing purposes.
    #result
  end
end
