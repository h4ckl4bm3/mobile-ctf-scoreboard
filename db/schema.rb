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

ActiveRecord::Schema.define(version: 20150724011524) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "attack_periods", force: :cascade do |t|
    t.datetime "start"
    t.datetime "finish"
    t.integer  "round_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "attack_periods", ["round_id"], name: "index_attack_periods_on_round_id", using: :btree

  create_table "defend_periods", force: :cascade do |t|
    t.datetime "start"
    t.datetime "finish"
    t.integer  "round_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "defend_periods", ["round_id"], name: "index_defend_periods_on_round_id", using: :btree

  create_table "flag_submissions", force: :cascade do |t|
    t.string   "flag"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer  "user_id"
    t.integer  "round_id"
    t.integer  "owner_id"
  end

  add_index "flag_submissions", ["owner_id"], name: "index_flag_submissions_on_owner_id", using: :btree
  add_index "flag_submissions", ["round_id"], name: "index_flag_submissions_on_round_id", using: :btree
  add_index "flag_submissions", ["user_id"], name: "index_flag_submissions_on_user_id", using: :btree

  create_table "flags", force: :cascade do |t|
    t.string   "flag"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer  "user_id"
    t.integer  "round_id"
  end

  add_index "flags", ["round_id"], name: "index_flags_on_round_id", using: :btree
  add_index "flags", ["user_id"], name: "index_flags_on_user_id", using: :btree

  create_table "integrities", force: :cascade do |t|
    t.boolean  "success"
    t.string   "method"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer  "user_id"
    t.integer  "round_id"
  end

  add_index "integrities", ["round_id"], name: "index_integrities_on_round_id", using: :btree
  add_index "integrities", ["user_id"], name: "index_integrities_on_user_id", using: :btree

  create_table "messages", force: :cascade do |t|
    t.string   "title"
    t.string   "message"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer  "user_id"
  end

  add_index "messages", ["user_id"], name: "index_messages_on_user_id", using: :btree

  create_table "rounds", force: :cascade do |t|
    t.datetime "start"
    t.datetime "finish"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "users", force: :cascade do |t|
    t.string   "email",                  default: "", null: false
    t.string   "encrypted_password",     default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet     "current_sign_in_ip"
    t.inet     "last_sign_in_ip"
    t.integer  "failed_attempts",        default: 0,  null: false
    t.string   "unlock_token"
    t.datetime "locked_at"
    t.string   "type"
    t.integer  "game_id"
    t.datetime "messages_stamp"
    t.string   "tags"
    t.string   "display_name"
    t.string   "city"
    t.float    "latitude"
    t.float    "longitude"
    t.string   "affiliation"
    t.datetime "created_at",                          null: false
    t.datetime "updated_at",                          null: false
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree

end
