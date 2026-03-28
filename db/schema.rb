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

ActiveRecord::Schema[8.0].define(version: 2026_03_28_164242) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_catalog.plpgsql"

  create_table "active_storage_attachments", force: :cascade do |t|
    t.string "name", null: false
    t.string "record_type", null: false
    t.bigint "record_id", null: false
    t.bigint "blob_id", null: false
    t.datetime "created_at", null: false
    t.index ["blob_id"], name: "index_active_storage_attachments_on_blob_id"
    t.index ["record_type", "record_id", "name", "blob_id"], name: "index_active_storage_attachments_uniqueness", unique: true
  end

  create_table "active_storage_blobs", force: :cascade do |t|
    t.string "key", null: false
    t.string "filename", null: false
    t.string "content_type"
    t.text "metadata"
    t.string "service_name", null: false
    t.bigint "byte_size", null: false
    t.string "checksum"
    t.datetime "created_at", null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "active_storage_variant_records", force: :cascade do |t|
    t.bigint "blob_id", null: false
    t.string "variation_digest", null: false
    t.index ["blob_id", "variation_digest"], name: "index_active_storage_variant_records_uniqueness", unique: true
  end

  create_table "availabilities", force: :cascade do |t|
    t.bigint "listing_id", null: false
    t.date "date"
    t.time "start_time"
    t.time "end_time"
    t.boolean "is_available"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["listing_id"], name: "index_availabilities_on_listing_id"
  end

  create_table "bookings", force: :cascade do |t|
    t.bigint "listing_id", null: false
    t.bigint "user_id", null: false
    t.datetime "start_time"
    t.datetime "end_time"
    t.decimal "hours"
    t.decimal "total_price"
    t.string "status"
    t.string "payment_gateway"
    t.string "payment_id"
    t.string "payment_order_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["listing_id"], name: "index_bookings_on_listing_id"
    t.index ["user_id"], name: "index_bookings_on_user_id"
  end

  create_table "gateway_configs", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.string "gateway"
    t.string "key_id"
    t.string "key_secret"
    t.boolean "active"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_gateway_configs_on_user_id"
  end

  create_table "listings", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.string "title"
    t.text "description"
    t.string "category"
    t.string "city"
    t.string "address"
    t.decimal "price_per_hour"
    t.integer "capacity"
    t.text "amenities"
    t.text "photos_data"
    t.string "status"
    t.decimal "avg_rating"
    t.integer "reviews_count"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "accepted_gateways", default: ["razorpay", "stripe"], array: true
    t.index ["user_id"], name: "index_listings_on_user_id"
  end

  create_table "notifications", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.text "message"
    t.string "link"
    t.boolean "read", default: false, null: false
    t.string "kind"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_notifications_on_user_id"
  end

  create_table "payments", force: :cascade do |t|
    t.bigint "booking_id", null: false
    t.string "gateway"
    t.string "order_id"
    t.string "payment_id"
    t.decimal "amount"
    t.string "currency"
    t.string "status"
    t.text "raw_response"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["booking_id"], name: "index_payments_on_booking_id"
  end

  create_table "reviews", force: :cascade do |t|
    t.bigint "booking_id", null: false
    t.bigint "listing_id", null: false
    t.bigint "user_id", null: false
    t.integer "rating"
    t.text "body"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["booking_id"], name: "index_reviews_on_booking_id"
    t.index ["listing_id"], name: "index_reviews_on_listing_id"
    t.index ["user_id"], name: "index_reviews_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.string "name"
    t.string "role"
    t.string "phone"
    t.text "bio"
    t.string "city"
    t.boolean "host_approved"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "active_storage_variant_records", "active_storage_blobs", column: "blob_id"
  add_foreign_key "availabilities", "listings"
  add_foreign_key "bookings", "listings"
  add_foreign_key "bookings", "users"
  add_foreign_key "gateway_configs", "users"
  add_foreign_key "listings", "users"
  add_foreign_key "notifications", "users"
  add_foreign_key "payments", "bookings"
  add_foreign_key "reviews", "bookings"
  add_foreign_key "reviews", "listings"
  add_foreign_key "reviews", "users"
end
