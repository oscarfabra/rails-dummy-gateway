class CreatePaymentStatuses < ActiveRecord::Migration
  def up
    create_table :payment_statuses do |t|
      t.string :status_name

      t.timestamps
    end

    PaymentStatus.create id: 1, status_name: "PENDING"
    PaymentStatus.create id: 9, status_name: "PAID"
  end

  def down
    drop_table :payment_statuses
  end
end
