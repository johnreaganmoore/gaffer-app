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

ActiveRecord::Schema.define(version: 20170614124046) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "contact_properties", force: :cascade do |t|
    t.string   "property"
    t.integer  "org_id"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
    t.string   "data_type"
    t.boolean  "show_in_table"
    t.index ["org_id"], name: "index_contact_properties_on_org_id", using: :btree
  end

  create_table "contact_values", force: :cascade do |t|
    t.integer  "contact_id"
    t.integer  "contact_property_id"
    t.string   "value"
    t.datetime "created_at",          null: false
    t.datetime "updated_at",          null: false
    t.datetime "date_value"
    t.float    "number_value"
    t.index ["contact_id"], name: "index_contact_values_on_contact_id", using: :btree
    t.index ["contact_property_id"], name: "index_contact_values_on_contact_property_id", using: :btree
  end

  create_table "contacts", force: :cascade do |t|
    t.integer  "org_id"
    t.string   "first_name"
    t.string   "last_name"
    t.string   "phone"
    t.string   "email"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["org_id"], name: "index_contacts_on_org_id", using: :btree
  end

  create_table "delayed_jobs", force: :cascade do |t|
    t.integer  "priority",   default: 0, null: false
    t.integer  "attempts",   default: 0, null: false
    t.text     "handler",                null: false
    t.text     "last_error"
    t.datetime "run_at"
    t.datetime "locked_at"
    t.datetime "failed_at"
    t.string   "locked_by"
    t.string   "queue"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["priority", "run_at"], name: "delayed_jobs_priority", using: :btree
  end

  create_table "email_templates", force: :cascade do |t|
    t.text     "body"
    t.string   "name"
    t.integer  "org_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["org_id"], name: "index_email_templates_on_org_id", using: :btree
  end

  create_table "fees", force: :cascade do |t|
    t.string   "label"
    t.integer  "total_amount"
    t.integer  "player_amount"
    t.integer  "team_id"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
    t.index ["team_id"], name: "index_fees_on_team_id", using: :btree
  end

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
    t.integer  "org_id"
    t.index ["org_id"], name: "index_invites_on_org_id", using: :btree
  end

  create_table "leads", force: :cascade do |t|
    t.string   "email"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "leagues", force: :cascade do |t|
    t.string   "name"
    t.integer  "org_id"
    t.datetime "created_at",       null: false
    t.datetime "updated_at",       null: false
    t.integer  "players_per_team"
    t.integer  "minutes_per_game"
    t.string   "facility_type"
    t.index ["org_id"], name: "index_leagues_on_org_id", using: :btree
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

  create_table "notes", force: :cascade do |t|
    t.integer  "contact_id"
    t.text     "body"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer  "creator_id"
    t.index ["contact_id"], name: "index_notes_on_contact_id", using: :btree
  end

  create_table "orgs", force: :cascade do |t|
    t.string   "name"
    t.string   "external_link"
    t.datetime "created_at",          null: false
    t.datetime "updated_at",          null: false
    t.string   "slug"
    t.string   "merchant_account_id"
  end

  create_table "people", force: :cascade do |t|
    t.datetime "created_at",                                                     null: false
    t.datetime "updated_at",                                                     null: false
    t.string   "email",                                          default: "",    null: false
    t.string   "encrypted_password",                             default: "",    null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",                                  default: 0,     null: false
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
    t.integer  "invitations_count",                              default: 0
    t.string   "customer_id"
    t.string   "street_address"
    t.string   "locality"
    t.string   "region"
    t.string   "postal_code"
    t.string   "merchant_account_id"
    t.string   "subscriptions",                                  default: [],                 array: true
    t.boolean  "show_contact_tags_in_table",                     default: true
    t.boolean  "show_contact_phone_in_table",                    default: false
    t.boolean  "show_contact_email_in_table",                    default: false
    t.boolean  "show_contact_next_task_in_table",                default: true
    t.boolean  "show_contact_last_activity_in_table",            default: true
    t.string   "authentication_token",                limit: 30
    t.index ["authentication_token"], name: "index_people_on_authentication_token", unique: true, using: :btree
    t.index ["email"], name: "index_people_on_email", unique: true, using: :btree
    t.index ["invitation_token"], name: "index_people_on_invitation_token", unique: true, using: :btree
    t.index ["invitations_count"], name: "index_people_on_invitations_count", using: :btree
    t.index ["invited_by_id"], name: "index_people_on_invited_by_id", using: :btree
    t.index ["reset_password_token"], name: "index_people_on_reset_password_token", unique: true, using: :btree
  end

  create_table "people_roles", id: false, force: :cascade do |t|
    t.integer "person_id"
    t.integer "role_id"
    t.index ["person_id", "role_id"], name: "index_people_roles_on_person_id_and_role_id", using: :btree
  end

  create_table "player_fees", force: :cascade do |t|
    t.integer  "person_id"
    t.integer  "fee_id"
    t.boolean  "paid"
    t.integer  "amount"
    t.string   "charge"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["fee_id"], name: "index_player_fees_on_fee_id", using: :btree
    t.index ["person_id"], name: "index_player_fees_on_person_id", using: :btree
  end

  create_table "playing_times", force: :cascade do |t|
    t.integer  "timeframe_id"
    t.integer  "season_id"
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
    t.index ["season_id"], name: "index_playing_times_on_season_id", using: :btree
    t.index ["timeframe_id"], name: "index_playing_times_on_timeframe_id", using: :btree
  end

  create_table "reminders", force: :cascade do |t|
    t.integer  "contact_id"
    t.string   "label"
    t.date     "next_date"
    t.string   "interval"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string   "status"
    t.integer  "creator_id"
    t.index ["contact_id"], name: "index_reminders_on_contact_id", using: :btree
  end

  create_table "roles", force: :cascade do |t|
    t.string   "name"
    t.string   "resource_type"
    t.integer  "resource_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["name", "resource_type", "resource_id"], name: "index_roles_on_name_and_resource_type_and_resource_id", using: :btree
    t.index ["name"], name: "index_roles_on_name", using: :btree
  end

  create_table "season_participations", force: :cascade do |t|
    t.integer  "person_id"
    t.integer  "team_season_id"
    t.datetime "created_at",                   null: false
    t.datetime "updated_at",                   null: false
    t.float    "amount_paid"
    t.float    "amount_refunded"
    t.boolean  "is_treasurer"
    t.string   "transactions",    default: [],              array: true
    t.index ["person_id"], name: "index_season_participations_on_person_id", using: :btree
    t.index ["team_season_id"], name: "index_season_participations_on_team_season_id", using: :btree
  end

  create_table "seasons", force: :cascade do |t|
    t.string   "website"
    t.string   "location"
    t.date     "start_date"
    t.date     "end_date"
    t.integer  "cost"
    t.integer  "total_games"
    t.string   "format"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
    t.string   "sport"
    t.float    "location_lat"
    t.float    "location_long"
    t.integer  "league_id"
    t.index ["league_id"], name: "index_seasons_on_league_id", using: :btree
  end

  create_table "sub_list_memberships", force: :cascade do |t|
    t.integer  "person_id"
    t.integer  "sub_list_id"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
    t.index ["person_id"], name: "index_sub_list_memberships_on_person_id", using: :btree
    t.index ["sub_list_id"], name: "index_sub_list_memberships_on_sub_list_id", using: :btree
  end

  create_table "sub_lists", force: :cascade do |t|
    t.string   "name"
    t.integer  "org_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["org_id"], name: "index_sub_lists_on_org_id", using: :btree
  end

  create_table "taggings", force: :cascade do |t|
    t.integer  "tag_id"
    t.string   "taggable_type"
    t.integer  "taggable_id"
    t.string   "tagger_type"
    t.integer  "tagger_id"
    t.string   "context",       limit: 128
    t.datetime "created_at"
    t.index ["context"], name: "index_taggings_on_context", using: :btree
    t.index ["tag_id", "taggable_id", "taggable_type", "context", "tagger_id", "tagger_type"], name: "taggings_idx", unique: true, using: :btree
    t.index ["tag_id"], name: "index_taggings_on_tag_id", using: :btree
    t.index ["taggable_id", "taggable_type", "context"], name: "index_taggings_on_taggable_id_and_taggable_type_and_context", using: :btree
    t.index ["taggable_id", "taggable_type", "tagger_id", "context"], name: "taggings_idy", using: :btree
    t.index ["taggable_id"], name: "index_taggings_on_taggable_id", using: :btree
    t.index ["taggable_type"], name: "index_taggings_on_taggable_type", using: :btree
    t.index ["tagger_id", "tagger_type"], name: "index_taggings_on_tagger_id_and_tagger_type", using: :btree
    t.index ["tagger_id"], name: "index_taggings_on_tagger_id", using: :btree
  end

  create_table "tags", force: :cascade do |t|
    t.string  "name"
    t.integer "taggings_count", default: 0
    t.index ["name"], name: "index_tags_on_name", unique: true, using: :btree
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

  create_table "team_seasons", force: :cascade do |t|
    t.integer  "team_id"
    t.integer  "season_id"
    t.integer  "cost"
    t.integer  "min_players"
    t.datetime "created_at",               null: false
    t.datetime "updated_at",               null: false
    t.string   "status"
    t.integer  "max_players"
    t.string   "transfers",   default: [],              array: true
    t.index ["season_id"], name: "index_team_seasons_on_season_id", using: :btree
    t.index ["team_id"], name: "index_team_seasons_on_team_id", using: :btree
  end

  create_table "teams", force: :cascade do |t|
    t.string   "name"
    t.string   "color"
    t.string   "logo"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string   "slug"
    t.integer  "org_id"
    t.index ["org_id"], name: "index_teams_on_org_id", using: :btree
  end

  create_table "timeframes", force: :cascade do |t|
    t.string   "day_of_week"
    t.string   "part_of_day"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  add_foreign_key "contact_properties", "orgs"
  add_foreign_key "contact_values", "contact_properties"
  add_foreign_key "contact_values", "contacts"
  add_foreign_key "email_templates", "orgs"
  add_foreign_key "fees", "teams"
  add_foreign_key "games", "locations"
  add_foreign_key "games", "seasons"
  add_foreign_key "invites", "orgs"
  add_foreign_key "leagues", "orgs"
  add_foreign_key "locations", "seasons"
  add_foreign_key "player_fees", "fees"
  add_foreign_key "player_fees", "people"
  add_foreign_key "playing_times", "seasons"
  add_foreign_key "playing_times", "timeframes"
  add_foreign_key "season_participations", "people"
  add_foreign_key "season_participations", "team_seasons"
  add_foreign_key "seasons", "leagues"
  add_foreign_key "sub_list_memberships", "people"
  add_foreign_key "sub_list_memberships", "sub_lists"
  add_foreign_key "sub_lists", "orgs"
  add_foreign_key "team_memberships", "people"
  add_foreign_key "team_memberships", "teams"
  add_foreign_key "team_seasons", "seasons"
  add_foreign_key "team_seasons", "teams"
  add_foreign_key "teams", "orgs"
end
