# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `rails
# db:schema:load`. When creating a new database, `rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2020_06_29_145715) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "pgcrypto"
  enable_extension "plpgsql"

  create_table "merchants", force: :cascade do |t|
    t.string "name", null: false
    t.string "description"
    t.string "email", null: false
    t.string "status", null: false
    t.integer "total_transaction_sum", default: 0, null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["email", "status"], name: "index_merchants_on_email_and_status"
    t.index ["email"], name: "index_merchants_on_email", unique: true
    t.index ["name"], name: "index_merchants_on_name", unique: true
  end

  create_table "payment_transactions", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.bigint "merchant_id", null: false
    t.uuid "parent_transaction_id"
    t.string "type", null: false
    t.integer "amount"
    t.string "status", null: false
    t.string "customer_email", null: false
    t.string "customer_phone"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["merchant_id"], name: "index_payment_transactions_on_merchant_id"
    t.index ["parent_transaction_id"], name: "index_payment_transactions_on_parent_transaction_id"
  end

  add_foreign_key "payment_transactions", "merchants"
end
