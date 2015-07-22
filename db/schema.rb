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

ActiveRecord::Schema.define(version: 20150722010703) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "availabilities", force: :cascade do |t|
    t.boolean  "success"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer  "team_id"
    t.integer  "round_id"
    t.integer  "hack_id"
  end

  add_index "availabilities", ["hack_id"], name: "index_availabilities_on_hack_id", using: :btree
  add_index "availabilities", ["round_id"], name: "index_availabilities_on_round_id", using: :btree
  add_index "availabilities", ["team_id"], name: "index_availabilities_on_team_id", using: :btree

  create_table "flag_submissions", force: :cascade do |t|
    t.string   "flag"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer  "team_id"
    t.integer  "round_id"
    t.integer  "owner_id"
  end

  add_index "flag_submissions", ["owner_id"], name: "index_flag_submissions_on_owner_id", using: :btree
  add_index "flag_submissions", ["round_id"], name: "index_flag_submissions_on_round_id", using: :btree
  add_index "flag_submissions", ["team_id"], name: "index_flag_submissions_on_team_id", using: :btree

  create_table "flags", force: :cascade do |t|
    t.string   "flag"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer  "team_id"
    t.integer  "round_id"
  end

  add_index "flags", ["round_id"], name: "index_flags_on_round_id", using: :btree
  add_index "flags", ["team_id"], name: "index_flags_on_team_id", using: :btree

  create_table "hacks", force: :cascade do |t|
    t.string   "hack"
    t.boolean  "success"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer  "team_id"
    t.integer  "target_id"
    t.integer  "round_id"
  end

  add_index "hacks", ["round_id"], name: "index_hacks_on_round_id", using: :btree
  add_index "hacks", ["target_id"], name: "index_hacks_on_target_id", using: :btree
  add_index "hacks", ["team_id"], name: "index_hacks_on_team_id", using: :btree

  create_table "integrities", force: :cascade do |t|
    t.boolean  "success"
    t.string   "method"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer  "team_id"
    t.integer  "round_id"
  end

  add_index "integrities", ["round_id"], name: "index_integrities_on_round_id", using: :btree
  add_index "integrities", ["team_id"], name: "index_integrities_on_team_id", using: :btree

  create_table "messages", force: :cascade do |t|
    t.string   "title"
    t.string   "message"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer  "team_id"
  end

  add_index "messages", ["team_id"], name: "index_messages_on_team_id", using: :btree

  create_table "rounds", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "teams", force: :cascade do |t|
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
    t.datetime "created_at",                          null: false
    t.datetime "updated_at",                          null: false
  end

  add_index "teams", ["email"], name: "index_teams_on_email", unique: true, using: :btree
  add_index "teams", ["reset_password_token"], name: "index_teams_on_reset_password_token", unique: true, using: :btree

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
    t.datetime "created_at",                          null: false
    t.datetime "updated_at",                          null: false
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree

end
