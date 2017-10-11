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

ActiveRecord::Schema.define(version: 20171011082227) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "enquiries", force: :cascade do |t|
    t.bigint "user_id"
    t.bigint "team_id"
    t.integer "user_uid"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "status"
    t.index ["team_id"], name: "index_enquiries_on_team_id"
    t.index ["user_id"], name: "index_enquiries_on_user_id"
  end

  create_table "games", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "happenings", force: :cascade do |t|
    t.string "name"
    t.datetime "time"
    t.string "location"
    t.text "detail"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "heroes", force: :cascade do |t|
    t.integer "api_id"
    t.string "api_name"
    t.string "name"
    t.decimal "win_rate", precision: 5, scale: 2
    t.decimal "picked", precision: 5, scale: 2
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "api_npc_name"
  end

  create_table "items", force: :cascade do |t|
    t.integer "api_id"
    t.string "api_name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["api_id"], name: "index_items_on_api_id"
  end

  create_table "members", force: :cascade do |t|
    t.bigint "team_id"
    t.string "name"
    t.integer "account_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["team_id"], name: "index_members_on_team_id"
  end

  create_table "participants", force: :cascade do |t|
    t.bigint "team_id"
    t.bigint "tournament_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["team_id"], name: "index_participants_on_team_id"
    t.index ["tournament_id"], name: "index_participants_on_tournament_id"
  end

  create_table "players", force: :cascade do |t|
    t.bigint "user_id"
    t.bigint "team_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "real_name"
    t.string "persona_name"
    t.string "team_name"
    t.integer "winrate", default: 0
    t.text "top_heroes", default: [], array: true
    t.integer "steam_id"
    t.string "avatar"
    t.string "profile_url"
    t.string "country_code"
    t.integer "mmr", default: 0
    t.date "last_login", default: "2017-10-09"
    t.index ["team_id"], name: "index_players_on_team_id"
    t.index ["user_id"], name: "index_players_on_user_id"
  end

  create_table "roles", force: :cascade do |t|
    t.string "game"
    t.string "position"
    t.string "team"
    t.boolean "captain"
    t.bigint "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_roles_on_user_id"
  end

  create_table "sponsors", force: :cascade do |t|
    t.string "company_name"
    t.string "company_email"
    t.integer "company_phone"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "sponsorships", force: :cascade do |t|
    t.bigint "sponsor_id"
    t.bigint "team_id"
    t.bigint "game_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["game_id"], name: "index_sponsorships_on_game_id"
    t.index ["sponsor_id"], name: "index_sponsorships_on_sponsor_id"
    t.index ["team_id"], name: "index_sponsorships_on_team_id"
  end

  create_table "teams", force: :cascade do |t|
    t.string "name"
    t.string "sponsor"
    t.string "coach"
    t.string "manager"
    t.string "country"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "status", default: true
    t.integer "dota2_team_id"
    t.bigint "user_id"
    t.float "winrate"
    t.text "roster", default: [], array: true
    t.integer "rating", default: 0
    t.string "logo"
    t.index ["user_id"], name: "index_teams_on_user_id"
  end

  create_table "titles", force: :cascade do |t|
    t.bigint "team_id"
    t.bigint "game_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["game_id"], name: "index_titles_on_game_id"
    t.index ["team_id"], name: "index_titles_on_team_id"
  end

  create_table "tournaments", force: :cascade do |t|
    t.string "name"
    t.datetime "start"
    t.datetime "end_date"
    t.string "game"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "status", default: true
    t.string "description"
    t.string "tournament_url"
    t.string "itemdef"
    t.string "image"
  end

  create_table "users", force: :cascade do |t|
    t.string "real_name"
    t.date "birthday"
    t.string "email"
    t.string "occupation"
    t.string "country"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "encrypted_password", limit: 128
    t.string "confirmation_token", limit: 128
    t.string "remember_token", limit: 128
    t.string "provider"
    t.string "uid"
    t.string "state"
    t.string "persona_name"
    t.string "avatar_url"
    t.index ["email"], name: "index_users_on_email"
    t.index ["remember_token"], name: "index_users_on_remember_token"
  end

  add_foreign_key "enquiries", "teams"
  add_foreign_key "enquiries", "users"
  add_foreign_key "members", "teams"
  add_foreign_key "participants", "teams"
  add_foreign_key "participants", "tournaments"
  add_foreign_key "players", "users"
  add_foreign_key "roles", "users"
  add_foreign_key "sponsorships", "games"
  add_foreign_key "sponsorships", "sponsors"
  add_foreign_key "sponsorships", "teams"
  add_foreign_key "teams", "users"
end
