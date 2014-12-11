class Order < ActiveRecord::Base
  has_many :payments

  # Validates that form values are appropriate.
  validates :total, :customer_id, :address, :email, :pay_type, presence: true

end
