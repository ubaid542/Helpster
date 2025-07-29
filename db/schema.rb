# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[8.0].define(version: 2025_07_29_095500) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_catalog.plpgsql"

  create_table "bookings", force: :cascade do |t|
    t.bigint "client_id"
    t.bigint "service_provider_id"
    t.bigint "service_id"
    t.date "date"
    t.string "time"
    t.string "status"
    t.decimal "price"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.text "address"
    t.text "notes"
    t.string "payment_status"
    t.string "payment_reference"
    t.datetime "paid_at"
    t.index ["client_id"], name: "index_bookings_on_client_id"
    t.index ["service_id"], name: "index_bookings_on_service_id"
    t.index ["service_provider_id"], name: "index_bookings_on_service_provider_id"
  end

  create_table "services", force: :cascade do |t|
    t.string "name"
    t.text "description"
    t.string "category"
    t.decimal "price"
    t.string "location"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "subcategory"
    t.bigint "provider_id"
    t.index ["provider_id"], name: "index_services_on_provider_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "type"
    t.string "full_name"
    t.string "phone_number"
    t.string "category"
    t.string "experience_years"
    t.text "short_info"
    t.string "country"
    t.string "province"
    t.string "city"
    t.text "address"
    t.text "subcategories", default: [], array: true
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "bookings", "services"
  add_foreign_key "bookings", "users", column: "client_id"
  add_foreign_key "bookings", "users", column: "service_provider_id"
end
