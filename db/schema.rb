# encoding: UTF-8
# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20141212000955) do

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

  create_table "payment_statuses", force: true do |t|
    t.string   "status_name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "payments", force: true do |t|
    t.string   "number"
    t.string   "month"
    t.string   "year"
    t.string   "first_name"
    t.string   "last_name"
    t.string   "verification_value"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "status",                                     default: 1,   null: false
    t.integer  "order_id"
    t.decimal  "amount",             precision: 8, scale: 2, default: 0.0, null: false
  end

  add_index "payments", ["order_id"], name: "index_payments_on_order_id"

end
