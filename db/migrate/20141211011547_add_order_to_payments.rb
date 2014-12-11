class AddOrderToPayments < ActiveRecord::Migration
  def change
    add_reference :payments, :order, index: true
  end
end
