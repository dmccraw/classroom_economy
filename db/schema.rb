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

ActiveRecord::Schema.define(version: 20150314054204) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "accounts", force: :cascade do |t|
    t.integer  "owner_id"
    t.string   "owner_type", limit: 255
    t.integer  "group_id"
    t.float    "balance"
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
  end

  add_index "accounts", ["group_id"], name: "index_accounts_on_group_id", using: :btree
  add_index "accounts", ["owner_id"], name: "index_accounts_on_owner_id", using: :btree

  create_table "bills", force: :cascade do |t|
    t.integer  "from_account_id"
    t.integer  "to_account_id"
    t.integer  "group_id"
    t.integer  "user_id"
    t.datetime "due_date"
    t.datetime "created_at",                  null: false
    t.datetime "updated_at",                  null: false
    t.boolean  "paid"
    t.datetime "paid_date"
    t.integer  "transfer_id"
    t.float    "amount"
    t.string   "description",     limit: 255
  end

  add_index "bills", ["from_account_id"], name: "index_bills_on_from_account_id", using: :btree
  add_index "bills", ["group_id"], name: "index_bills_on_group_id", using: :btree
  add_index "bills", ["to_account_id"], name: "index_bills_on_to_account_id", using: :btree
  add_index "bills", ["user_id"], name: "index_bills_on_user_id", using: :btree

  create_table "charges", force: :cascade do |t|
    t.integer  "account_id"
    t.integer  "group_id"
    t.string   "description", limit: 255
    t.float    "amount"
    t.datetime "created_at",              null: false
    t.datetime "updated_at",              null: false
  end

  add_index "charges", ["account_id"], name: "index_charges_on_user_id", using: :btree
  add_index "charges", ["group_id"], name: "index_charges_on_group_id", using: :btree

  create_table "disputes", force: :cascade do |t|
    t.integer  "owner_id"
    t.string   "owner_type",         limit: 255
    t.integer  "transfer_id"
    t.integer  "group_id"
    t.text     "reason"
    t.integer  "result"
    t.text     "result_reason"
    t.integer  "result_transfer_id"
    t.datetime "created_at",                     null: false
    t.datetime "updated_at",                     null: false
  end

  add_index "disputes", ["group_id"], name: "index_disputes_on_group_id", using: :btree
  add_index "disputes", ["owner_id"], name: "index_disputes_on_owner_id", using: :btree
  add_index "disputes", ["owner_type"], name: "index_disputes_on_owner_type", using: :btree
  add_index "disputes", ["result_transfer_id"], name: "index_disputes_on_result_transaction_id", using: :btree
  add_index "disputes", ["transfer_id"], name: "index_disputes_on_transaction_id", using: :btree

  create_table "groups", force: :cascade do |t|
    t.string   "name",       limit: 255, null: false
    t.integer  "user_id",                null: false
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
  end

  create_table "job_assignments", force: :cascade do |t|
    t.integer  "job_id"
    t.integer  "user_id"
    t.integer  "group_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "job_assignments", ["group_id"], name: "index_job_assignments_on_group_id", using: :btree
  add_index "job_assignments", ["job_id"], name: "index_job_assignments_on_job_id", using: :btree
  add_index "job_assignments", ["user_id"], name: "index_job_assignments_on_user_id", using: :btree

  create_table "jobs", force: :cascade do |t|
    t.string   "title",       limit: 255
    t.string   "description", limit: 255
    t.float    "salary"
    t.integer  "group_id"
    t.datetime "created_at",              null: false
    t.datetime "updated_at",              null: false
  end

  add_index "jobs", ["group_id"], name: "index_jobs_on_group_id", using: :btree

  create_table "memberships", force: :cascade do |t|
    t.integer  "user_id",    null: false
    t.integer  "group_id",   null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "memberships", ["group_id"], name: "index_memberships_on_group_id", using: :btree
  add_index "memberships", ["user_id"], name: "index_memberships_on_user_id", using: :btree

  create_table "store_managers", force: :cascade do |t|
    t.integer  "store_id"
    t.integer  "user_id"
    t.integer  "manage_level"
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
    t.float    "salary"
  end

  add_index "store_managers", ["store_id"], name: "index_store_managers_on_store_id", using: :btree
  add_index "store_managers", ["user_id"], name: "index_store_managers_on_user_id", using: :btree

  create_table "store_owners", force: :cascade do |t|
    t.integer  "user_id",    null: false
    t.integer  "store_id",   null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "store_owners", ["store_id"], name: "index_store_owners_on_store_id", using: :btree
  add_index "store_owners", ["user_id"], name: "index_store_owners_on_user_id", using: :btree

  create_table "stores", force: :cascade do |t|
    t.string   "name",        limit: 255,                 null: false
    t.text     "description"
    t.boolean  "approved",                default: false, null: false
    t.integer  "group_id",                                null: false
    t.datetime "created_at",                              null: false
    t.datetime "updated_at",                              null: false
  end

  add_index "stores", ["group_id"], name: "index_stores_on_group_id", using: :btree

  create_table "transfers", force: :cascade do |t|
    t.integer  "from_account_id",                             null: false
    t.integer  "to_account_id",                               null: false
    t.integer  "group_id",                                    null: false
    t.float    "amount",                                      null: false
    t.string   "description",     limit: 255,                 null: false
    t.datetime "occurred_on",                                 null: false
    t.integer  "user_id",                                     null: false
    t.boolean  "disputed",                    default: false, null: false
    t.datetime "created_at",                                  null: false
    t.datetime "updated_at",                                  null: false
  end

  add_index "transfers", ["from_account_id"], name: "index_transactions_on_from_account_id", using: :btree
  add_index "transfers", ["group_id"], name: "index_transactions_on_group_id", using: :btree
  add_index "transfers", ["to_account_id"], name: "index_transactions_on_to_account_id", using: :btree
  add_index "transfers", ["user_id"], name: "index_transactions_on_user_id", using: :btree

  create_table "users", force: :cascade do |t|
    t.string   "first_name",             limit: 255,              null: false
    t.string   "last_name",              limit: 255,              null: false
    t.string   "username",               limit: 255,              null: false
    t.integer  "user_type",                                       null: false
    t.datetime "created_at",                                      null: false
    t.datetime "updated_at",                                      null: false
    t.string   "email",                  limit: 255, default: "", null: false
    t.string   "encrypted_password",     limit: 255, default: "", null: false
    t.string   "reset_password_token",   limit: 255
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",                      default: 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip",     limit: 255
    t.string   "last_sign_in_ip",        limit: 255
    t.string   "confirmation_token",     limit: 255
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string   "unconfirmed_email",      limit: 255
    t.string   "time_zone",              limit: 255
  end

  add_index "users", ["confirmation_token"], name: "index_users_on_confirmation_token", unique: true, using: :btree
  add_index "users", ["email"], name: "index_users_on_email", using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree

end
