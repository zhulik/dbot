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

ActiveRecord::Schema.define(version: 20180128185109) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"
  enable_extension "fuzzystrmatch"
  enable_extension "pg_trgm"

  create_table "languages", force: :cascade do |t|
    t.string "name", null: false
    t.string "code", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["code"], name: "index_languages_on_code", unique: true
  end

  create_table "practice_stats", force: :cascade do |t|
    t.bigint "user_id"
    t.string "practice", null: false
    t.string "status", default: "in_progress", null: false
    t.jsonb "stats", default: {}
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "message_id", null: false
    t.bigint "chat_id", null: false
    t.index ["message_id", "chat_id"], name: "index_practice_stats_on_message_id_and_chat_id", unique: true
    t.index ["stats"], name: "index_practice_stats_on_stats", using: :gin
    t.index ["user_id"], name: "index_practice_stats_on_user_id"
  end

  create_table "tts_phrases", force: :cascade do |t|
    t.string "phrase", null: false
    t.bigint "language_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "voice", null: false
    t.index ["language_id"], name: "index_tts_phrases_on_language_id"
    t.index ["phrase", "language_id"], name: "index_tts_phrases_on_phrase_and_language_id", unique: true
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
    t.float "sm2_easiness_factor", default: 2.5
    t.date "sm2_practice_date"
    t.jsonb "practice_stats", default: {}, null: false
    t.index ["language_id"], name: "index_words_on_language_id"
    t.index ["practice_stats"], name: "index_words_on_practice_stats", using: :gin
    t.index ["user_id", "language_id", "word", "translation"], name: "index_words_on_user_id_and_language_id_and_word_and_translation", unique: true
    t.index ["user_id"], name: "index_words_on_user_id"
  end

  add_foreign_key "practice_stats", "users"
  add_foreign_key "tts_phrases", "languages"
  add_foreign_key "users", "languages", on_delete: :nullify
  add_foreign_key "words", "languages", on_delete: :cascade
  add_foreign_key "words", "users", on_delete: :cascade
end
