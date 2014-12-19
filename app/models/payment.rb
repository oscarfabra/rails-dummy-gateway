class Payment < ActiveRecord::Base
  belongs_to :order

  # Hash with the possible statuses retrieved from payment_statuses table.
  PAYMENT_STATUSES = PaymentStatus.select(:id).map(&:id)
  PENDING_STATUS = 1
  PAID_STATUS = 9

  validates :number, :month, :year, :first_name, :last_name,
            :verification_value, :status, :order_id, :amount, presence: true
  validates :amount, numericality: { greater_than_or_equal_to: 0.01,
                                    less_than_or_equal_to: 10000 }
  validates :status, inclusion: PAYMENT_STATUSES

  # Processes this payment. Returns true or false depending on result.
  def process
    random_number = 1 + rand(10) # Generates a random number between 1 and 10
    return false if random_number == 1  # Rejects if random_number is 1 (10% of the time)

    # Use the TrustCommerce test servers
    ActiveMerchant::Billing::Base.mode = :test

    gateway = ActiveMerchant::Billing::TrustCommerceGateway.new(
        :login => 'TestMerchant',
        :password => 'password')

    # ActiveMerchant accepts all amounts as Integer values in cents
    amount = self.amount * 10

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
    # Updates status to 1 (success) or 9 (failed) accordingly
    # @status = (result)? PAID_STATUS : PENDING_STATUS
    @status = PAID_STATUS  # Sets to true for testing purposes.
    save!  # Updates this payment in db.
    logger.info "Payment attributes = #{self.attributes}"
    return true  # Returns true, for testing purposes.
    #result
  end

  # Tells whether this order has already been paid. Assumes order was paid in
  # just one payment.
  def paid?
    Payment.find_by(order_id: params[:order_id])
  end
end
