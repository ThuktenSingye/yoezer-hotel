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

ActiveRecord::Schema[8.0].define(version: 2025_02_12_181918) do
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

  create_table "addresses", force: :cascade do |t|
    t.string "dzongkhag"
    t.string "gewog"
    t.text "street_address"
    t.integer "address_type", default: 0, null: false
    t.string "addressable_type", null: false
    t.bigint "addressable_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["addressable_type", "addressable_id"], name: "index_addresses_on_addressable"
  end

  create_table "admin_hotels", force: :cascade do |t|
    t.string "name"
    t.string "email"
    t.string "contact_no"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "admins", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "hotel_id"
    t.index ["email"], name: "index_admins_on_email", unique: true
    t.index ["hotel_id"], name: "index_admins_on_hotel_id"
    t.index ["reset_password_token"], name: "index_admins_on_reset_password_token", unique: true
  end

  create_table "amenities", force: :cascade do |t|
    t.string "name"
    t.string "amenityable_type", null: false
    t.bigint "amenityable_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["amenityable_type", "amenityable_id"], name: "index_amenities_on_amenityable"
  end

  create_table "bed_types", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "hotel_id"
    t.index ["hotel_id"], name: "index_bed_types_on_hotel_id"
    t.index ["name"], name: "index_bed_types_on_name", unique: true
  end

  create_table "bookings", force: :cascade do |t|
    t.datetime "checkin_date"
    t.datetime "checkout_date"
    t.integer "num_of_adult"
    t.integer "num_of_children"
    t.integer "payment_status"
    t.decimal "total_amount"
    t.string "confirmation_token"
    t.boolean "confirmed"
    t.bigint "guest_id", null: false
    t.bigint "room_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "hotel_id"
    t.datetime "confirmation_sent_at", default: -> { "CURRENT_TIMESTAMP" }
    t.datetime "confirmation_expires_at"
    t.string "feedback_token"
    t.datetime "feedback_expires_at"
    t.index ["feedback_token"], name: "index_bookings_on_feedback_token"
    t.index ["guest_id"], name: "index_bookings_on_guest_id"
    t.index ["hotel_id"], name: "index_bookings_on_hotel_id"
    t.index ["room_id"], name: "index_bookings_on_room_id"
  end

  create_table "employees", force: :cascade do |t|
    t.string "email"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "hotel_id"
    t.bigint "profile_id"
    t.index ["email"], name: "index_employees_on_email", unique: true
    t.index ["hotel_id"], name: "index_employees_on_hotel_id"
    t.index ["profile_id"], name: "index_employees_on_profile_id"
  end

  create_table "facilities", force: :cascade do |t|
    t.string "name"
    t.bigint "hotel_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["hotel_id"], name: "index_facilities_on_hotel_id"
    t.index ["name"], name: "index_facilities_on_name", unique: true
  end

  create_table "feedbacks", force: :cascade do |t|
    t.string "name"
    t.string "email"
    t.text "feedback"
    t.bigint "hotel_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["hotel_id"], name: "index_feedbacks_on_hotel_id"
  end

  create_table "guests", force: :cascade do |t|
    t.string "first_name"
    t.string "last_name"
    t.string "contact_no"
    t.string "email"
    t.string "country"
    t.string "region"
    t.string "city"
    t.bigint "hotel_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["hotel_id"], name: "index_guests_on_hotel_id"
  end

  create_table "hotel_galleries", force: :cascade do |t|
    t.string "name"
    t.text "description"
    t.bigint "hotel_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["hotel_id"], name: "index_hotel_galleries_on_hotel_id"
  end

  create_table "hotel_ratings", force: :cascade do |t|
    t.integer "rating", default: 0
    t.bigint "hotel_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "guest_id"
    t.index ["guest_id"], name: "index_hotel_ratings_on_guest_id"
    t.index ["hotel_id"], name: "index_hotel_ratings_on_hotel_id"
  end

  create_table "hotels", force: :cascade do |t|
    t.string "name"
    t.string "email"
    t.string "contact_no"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.text "description"
    t.string "subdomain"
    t.index ["subdomain"], name: "index_hotels_on_subdomain", unique: true
  end

  create_table "offers", force: :cascade do |t|
    t.string "title"
    t.text "description"
    t.date "start_time", default: -> { "CURRENT_TIMESTAMP" }
    t.date "end_time"
    t.integer "discount"
    t.bigint "hotel_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["hotel_id"], name: "index_offers_on_hotel_id"
  end

  create_table "profiles", force: :cascade do |t|
    t.string "first_name"
    t.string "last_name"
    t.string "cid_no"
    t.integer "designation"
    t.date "date_of_joining"
    t.string "contact_no"
    t.decimal "salary"
    t.date "dob"
    t.string "qualification"
    t.string "profileable_type", null: false
    t.bigint "profileable_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["cid_no"], name: "index_profiles_on_cid_no", unique: true
    t.index ["profileable_type", "profileable_id"], name: "index_profiles_on_profileable"
  end

  create_table "room_bed_types", force: :cascade do |t|
    t.bigint "room_id", null: false
    t.bigint "bed_type_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "num_of_bed", default: 0
    t.index ["bed_type_id"], name: "index_room_bed_types_on_bed_type_id"
    t.index ["room_id"], name: "index_room_bed_types_on_room_id"
  end

  create_table "room_categories", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "hotel_id"
    t.index ["hotel_id"], name: "index_room_categories_on_hotel_id"
    t.index ["name"], name: "index_room_categories_on_name", unique: true
  end

  create_table "room_facilities", force: :cascade do |t|
    t.bigint "room_id", null: false
    t.bigint "facility_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["facility_id"], name: "index_room_facilities_on_facility_id"
    t.index ["room_id"], name: "index_room_facilities_on_room_id"
  end

  create_table "room_ratings", force: :cascade do |t|
    t.integer "rating", default: 0
    t.bigint "room_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "guest_id"
    t.index ["guest_id"], name: "index_room_ratings_on_guest_id"
    t.index ["room_id"], name: "index_room_ratings_on_room_id"
  end

  create_table "rooms", force: :cascade do |t|
    t.string "room_number"
    t.integer "floor_number"
    t.integer "status"
    t.decimal "base_price", precision: 10, scale: 2
    t.text "description"
    t.integer "max_no_adult"
    t.integer "max_no_children"
    t.bigint "room_category_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "hotel_id"
    t.index ["hotel_id"], name: "index_rooms_on_hotel_id"
    t.index ["room_category_id"], name: "index_rooms_on_room_category_id"
    t.index ["room_number"], name: "index_rooms_on_room_number", unique: true
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "active_storage_variant_records", "active_storage_blobs", column: "blob_id"
  add_foreign_key "admins", "hotels"
  add_foreign_key "bed_types", "hotels"
  add_foreign_key "bookings", "guests"
  add_foreign_key "bookings", "hotels"
  add_foreign_key "bookings", "rooms"
  add_foreign_key "employees", "hotels"
  add_foreign_key "employees", "profiles"
  add_foreign_key "facilities", "hotels"
  add_foreign_key "feedbacks", "hotels"
  add_foreign_key "guests", "hotels"
  add_foreign_key "hotel_galleries", "hotels"
  add_foreign_key "hotel_ratings", "guests"
  add_foreign_key "hotel_ratings", "hotels"
  add_foreign_key "offers", "hotels"
  add_foreign_key "room_bed_types", "bed_types"
  add_foreign_key "room_bed_types", "rooms"
  add_foreign_key "room_categories", "hotels"
  add_foreign_key "room_facilities", "facilities"
  add_foreign_key "room_facilities", "rooms"
  add_foreign_key "room_ratings", "guests"
  add_foreign_key "room_ratings", "rooms"
  add_foreign_key "rooms", "hotels"
  add_foreign_key "rooms", "room_categories"
end
