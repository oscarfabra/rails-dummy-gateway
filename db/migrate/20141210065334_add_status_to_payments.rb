class AddStatusToPayments < ActiveRecord::Migration
  def change
    add_column :payments, :status, :integer, default: 1, null: false
  end
end
