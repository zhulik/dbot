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

ActiveRecord::Schema.define(version: 20180106112725) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "languages", force: :cascade do |t|
    t.string "name", null: false
    t.string "code", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["code"], name: "index_languages_on_code", unique: true
  end

  create_table "users", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.boolean "active", default: true, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "language_id"
    t.string "username"
    t.index ["user_id"], name: "index_users_on_user_id", unique: true
  end

  create_table "words", force: :cascade do |t|
    t.bigint "user_id"
    t.bigint "language_id"
    t.string "word", null: false
    t.string "translation", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "pos", null: false
    t.string "gen"
    t.integer "wordsfrom_success", default: 0, null: false
    t.integer "wordsfrom_fail", default: 0, null: false
    t.integer "wordsto_success", default: 0, null: false
    t.integer "wordsto_fail", default: 0, null: false
    t.index ["language_id"], name: "index_words_on_language_id"
    t.index ["user_id", "language_id", "word"], name: "index_words_on_user_id_and_language_id_and_word", unique: true
    t.index ["user_id"], name: "index_words_on_user_id"
  end

  add_foreign_key "users", "languages", on_delete: :nullify
  add_foreign_key "words", "languages", on_delete: :cascade
  add_foreign_key "words", "users", on_delete: :cascade
end
