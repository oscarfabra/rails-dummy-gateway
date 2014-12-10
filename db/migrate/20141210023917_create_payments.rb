class CreatePayments < ActiveRecord::Migration
  def change
    create_table :payments do |t|
      t.string :number
      t.string :month
      t.string :year
      t.string :first_name
      t.string :last_name
      t.string :verification_value

      t.timestamps
    end
  end
end
