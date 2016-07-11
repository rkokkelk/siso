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

ActiveRecord::Schema.define(version: 20160504195931) do


  create_table "audits", force: :cascade do |t|
    t.string   "token"
    t.string   "message"
    t.date     "deletion"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "bricks", force: :cascade do |t|
    t.string "token"
    t.binary "blob"
  end

  create_table "records", force: :cascade do |t|
    t.string   "iv_enc",          null: false
    t.string   "token",           null: false
    t.string   "file_name_enc",   null: false
    t.string   "size_enc",        null: false
    t.integer  "repositories_id", null: false
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
  end

  add_index "records", ["repositories_id"], name: "index_records_on_repositories_id"

  create_table "repositories", force: :cascade do |t|
    t.string   "iv_enc",          null: false
    t.string   "master_key_enc",  null: false
    t.string   "password_digest", null: false
    t.string   "title_enc",       null: false
    t.text     "description_enc"
    t.string   "token",           null: false
    t.datetime "created_at",      null: false
    t.datetime "deleted_at",      null: false
    t.datetime "updated_at",      null: false
  end
end
