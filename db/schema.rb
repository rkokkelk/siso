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

ActiveRecord::Schema.define(version: 20151130190843) do

  create_table "keys", force: :cascade do |t|
    t.string   "password_digest"
    t.string   "master_key_enc"
    t.string   "token"
    t.integer  "repository_id"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
  end

  add_index "keys", ["repository_id"], name: "index_keys_on_repository_id"

  create_table "records", force: :cascade do |t|
    t.string   "iv"
    t.string   "token"
    t.string   "file_name"
    t.integer  "size"
    t.date     "creation"
    t.integer  "repositories_id"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
  end

  add_index "records", ["repositories_id"], name: "index_records_on_repositories_id"

  create_table "repositories", force: :cascade do |t|
    t.string "iv_enc"
    t.string "master_key_enc"
    t.string "password_digest"
    t.string "title_enc"
    t.text   "description_enc"
    t.date   "deletion"
    t.string "token"
    t.date   "creation"
  end

end
