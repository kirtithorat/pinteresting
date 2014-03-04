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

ActiveRecord::Schema.define(version: 20140303202529) do

  create_table "boards", force: true do |t|
    t.string   "name",        null: false
    t.text     "description"
    t.string   "category",    null: false
    t.integer  "member_id",   null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "boards", ["member_id"], name: "index_boards_on_member_id"
  add_index "boards", ["name", "member_id"], name: "index_boards_on_name_and_member_id", unique: true

  create_table "members", force: true do |t|
    t.string   "firstname",                                        null: false
    t.string   "lastname"
    t.string   "membername",                                       null: false
    t.text     "description"
    t.string   "gender"
    t.string   "location",               default: "United States", null: false
    t.string   "avatar_file_name"
    t.string   "avatar_content_type"
    t.integer  "avatar_file_size"
    t.datetime "avatar_updated_at"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "email",                  default: "",              null: false
    t.string   "encrypted_password",     default: "",              null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,               null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.string   "provider"
    t.string   "uid"
  end

  add_index "members", ["email"], name: "index_members_on_email", unique: true
  add_index "members", ["membername"], name: "index_members_on_membername", unique: true
  add_index "members", ["reset_password_token"], name: "index_members_on_reset_password_token", unique: true

  create_table "pins", force: true do |t|
    t.text     "description",        null: false
    t.string   "image_file_name"
    t.string   "image_content_type"
    t.integer  "image_file_size"
    t.datetime "image_updated_at"
    t.integer  "board_id",           null: false
    t.integer  "member_id",          null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "pins", ["board_id"], name: "index_pins_on_board_id"
  add_index "pins", ["member_id"], name: "index_pins_on_member_id"

end
