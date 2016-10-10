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

ActiveRecord::Schema.define(version: 20161006141302) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "games", force: :cascade do |t|
    t.integer  "season_id"
    t.integer  "location_id"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
    t.index ["location_id"], name: "index_games_on_location_id", using: :btree
    t.index ["season_id"], name: "index_games_on_season_id", using: :btree
  end

  create_table "invites", force: :cascade do |t|
    t.string   "email"
    t.string   "first_name"
    t.string   "last_name"
    t.integer  "team_id"
    t.integer  "sender_id"
    t.integer  "recipient_id"
    t.string   "token"
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
  end

  create_table "locations", force: :cascade do |t|
    t.string   "name"
    t.text     "address"
    t.float    "latitude"
    t.float    "longitude"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer  "season_id"
    t.index ["season_id"], name: "index_locations_on_season_id", using: :btree
  end

  create_table "people", force: :cascade do |t|
    t.datetime "created_at",                          null: false
    t.datetime "updated_at",                          null: false
    t.string   "email",                  default: "", null: false
    t.string   "encrypted_password",     default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.string   "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string   "unconfirmed_email"
    t.string   "provider"
    t.string   "uid"
    t.string   "first_name"
    t.string   "last_name"
    t.string   "phone"
    t.date     "date_of_birth"
    t.string   "avatar"
    t.string   "invitation_token"
    t.datetime "invitation_created_at"
    t.datetime "invitation_sent_at"
    t.datetime "invitation_accepted_at"
    t.integer  "invitation_limit"
    t.string   "invited_by_type"
    t.integer  "invited_by_id"
    t.integer  "invitations_count",      default: 0
    t.string   "braintree_customer_id"
    t.string   "street_address"
    t.string   "locality"
    t.string   "region"
    t.string   "postal_code"
    t.index ["email"], name: "index_people_on_email", unique: true, using: :btree
    t.index ["invitation_token"], name: "index_people_on_invitation_token", unique: true, using: :btree
    t.index ["invitations_count"], name: "index_people_on_invitations_count", using: :btree
    t.index ["invited_by_id"], name: "index_people_on_invited_by_id", using: :btree
    t.index ["reset_password_token"], name: "index_people_on_reset_password_token", unique: true, using: :btree
  end

  create_table "playing_times", force: :cascade do |t|
    t.integer  "timeframe_id"
    t.integer  "season_id"
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
    t.index ["season_id"], name: "index_playing_times_on_season_id", using: :btree
    t.index ["timeframe_id"], name: "index_playing_times_on_timeframe_id", using: :btree
  end

  create_table "season_participations", force: :cascade do |t|
    t.integer  "person_id"
    t.integer  "season_id"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
    t.float    "amount_paid"
    t.float    "amount_refunded"
    t.boolean  "is_treasurer"
    t.index ["person_id"], name: "index_season_participations_on_person_id", using: :btree
    t.index ["season_id"], name: "index_season_participations_on_season_id", using: :btree
  end

  create_table "seasons", force: :cascade do |t|
    t.integer  "team_id"
    t.string   "league_name"
    t.string   "website"
    t.string   "location"
    t.date     "start_date"
    t.date     "end_date"
    t.integer  "cost"
    t.integer  "total_games"
    t.string   "format"
    t.integer  "min_players"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
    t.string   "sport"
    t.index ["team_id"], name: "index_seasons_on_team_id", using: :btree
  end

  create_table "team_memberships", force: :cascade do |t|
    t.string   "position"
    t.integer  "team_id"
    t.integer  "person_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["person_id"], name: "index_team_memberships_on_person_id", using: :btree
    t.index ["team_id"], name: "index_team_memberships_on_team_id", using: :btree
  end

  create_table "teams", force: :cascade do |t|
    t.string   "name"
    t.string   "color"
    t.string   "logo"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string   "slug"
  end

  create_table "timeframes", force: :cascade do |t|
    t.string   "day_of_week"
    t.string   "part_of_day"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  add_foreign_key "games", "locations"
  add_foreign_key "games", "seasons"
  add_foreign_key "locations", "seasons"
  add_foreign_key "playing_times", "seasons"
  add_foreign_key "playing_times", "timeframes"
  add_foreign_key "season_participations", "people"
  add_foreign_key "season_participations", "seasons"
  add_foreign_key "seasons", "teams"
  add_foreign_key "team_memberships", "people"
  add_foreign_key "team_memberships", "teams"
end
