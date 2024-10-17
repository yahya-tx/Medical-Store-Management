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

ActiveRecord::Schema[7.1].define(version: 2024_10_17_102252) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

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

  create_table "archives", force: :cascade do |t|
    t.jsonb "archive_data"
    t.datetime "archived_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "audit_logs", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.integer "total_records_count"
    t.decimal "total_amount"
    t.integer "total_medicines_sold"
    t.datetime "audited_from"
    t.datetime "audited_to"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "branch_id"
    t.text "description"
    t.jsonb "medicine_details", default: {}
    t.index ["user_id"], name: "index_audit_logs_on_user_id"
  end

  create_table "branches", force: :cascade do |t|
    t.string "name"
    t.string "location"
    t.jsonb "stock", default: {}
    t.bigint "user_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_branches_on_user_id"
  end

  create_table "disputes", force: :cascade do |t|
    t.text "reason"
    t.bigint "customer_id"
    t.integer "status"
    t.bigint "branch_id"
    t.bigint "record_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["branch_id"], name: "index_disputes_on_branch_id"
    t.index ["customer_id"], name: "index_disputes_on_customer_id"
    t.index ["record_id"], name: "index_disputes_on_record_id"
  end

  create_table "medicines", force: :cascade do |t|
    t.string "name"
    t.text "description"
    t.decimal "price"
    t.integer "quantity"
    t.bigint "branch_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "product_code"
    t.date "expiry_date"
    t.boolean "expired", default: false
    t.index ["branch_id"], name: "index_medicines_on_branch_id"
  end

  create_table "notifications", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.text "message"
    t.integer "notification_type"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "read", default: false
    t.integer "order_id"
    t.index ["user_id"], name: "index_notifications_on_user_id"
  end

  create_table "records", force: :cascade do |t|
    t.bigint "customer_id"
    t.bigint "cashier_id", null: false
    t.decimal "total_amount"
    t.integer "payment_method"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.jsonb "medicine_ids", default: []
    t.string "customer_contact"
    t.integer "number_of_tablets"
    t.integer "branch_id"
    t.string "address"
    t.integer "postal_code"
    t.string "tracking_id"
    t.string "payment_intent_id"
    t.index ["cashier_id"], name: "index_records_on_cashier_id"
    t.index ["customer_id"], name: "index_records_on_customer_id"
  end

  create_table "refunds", force: :cascade do |t|
    t.integer "status"
    t.text "reason"
    t.jsonb "medicine_details"
    t.bigint "customer_id"
    t.bigint "branch_id"
    t.bigint "branch_admin_id"
    t.bigint "record_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["branch_admin_id"], name: "index_refunds_on_branch_admin_id"
    t.index ["branch_id"], name: "index_refunds_on_branch_id"
    t.index ["customer_id"], name: "index_refunds_on_customer_id"
    t.index ["record_id"], name: "index_refunds_on_record_id"
  end

  create_table "stock_transfers", force: :cascade do |t|
    t.bigint "to_branch_id", null: false
    t.integer "quantity"
    t.integer "status"
    t.bigint "requested_by_id", null: false
    t.bigint "approved_by_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.jsonb "medicine_ids", default: []
    t.integer "branch_id"
    t.string "pdf"
    t.index ["approved_by_id"], name: "index_stock_transfers_on_approved_by_id"
    t.index ["requested_by_id"], name: "index_stock_transfers_on_requested_by_id"
    t.index ["to_branch_id"], name: "index_stock_transfers_on_to_branch_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "name"
    t.string "email"
    t.string "encrypted_password"
    t.integer "role"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "phone_number"
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer "branch_id"
    t.integer "sign_in_count", default: 0, null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string "current_sign_in_ip"
    t.string "last_sign_in_ip"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "active_storage_variant_records", "active_storage_blobs", column: "blob_id"
  add_foreign_key "audit_logs", "users"
  add_foreign_key "branches", "users"
  add_foreign_key "disputes", "branches"
  add_foreign_key "disputes", "records"
  add_foreign_key "disputes", "users", column: "customer_id"
  add_foreign_key "medicines", "branches"
  add_foreign_key "notifications", "users"
  add_foreign_key "records", "users", column: "cashier_id"
  add_foreign_key "records", "users", column: "customer_id"
  add_foreign_key "refunds", "branches"
  add_foreign_key "refunds", "records"
  add_foreign_key "refunds", "users", column: "branch_admin_id"
  add_foreign_key "refunds", "users", column: "customer_id"
  add_foreign_key "stock_transfers", "branches", column: "to_branch_id"
  add_foreign_key "stock_transfers", "users", column: "approved_by_id"
  add_foreign_key "stock_transfers", "users", column: "requested_by_id"
  add_foreign_key "users", "branches"
end
