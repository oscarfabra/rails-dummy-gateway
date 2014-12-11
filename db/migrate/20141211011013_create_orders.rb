class CreateOrders < ActiveRecord::Migration
  def change
    create_table "orders", force: true do |t|
      t.text     "address"
      t.string   "email"
      t.string   "pay_type"
      t.datetime "created_at"
      t.datetime "updated_at"
      t.integer  "payment_type_id"
      t.datetime "ship_date"
      t.string   "order_no",                                default: "O0000001", null: false
      t.integer  "customer_id",                             default: 1,          null: false
      t.decimal  "total",           precision: 8, scale: 2, default: 0.0,        null: false
    end
  end
end
