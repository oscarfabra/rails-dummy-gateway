class Payment < ActiveRecord::Base
  validates :number, :month, :year, :first_name, :last_name,
            :verification_value, presence: true

  # Processes this payment. Returns true or false depending on result.
  def process
    random_number = 1 + rand(10) # Generates a random number between 1 and 10
    return false if random_number == 1  # Rejects if random_number is 1

    # TODO: Process payment with ActiveMerchant.

  end
end
