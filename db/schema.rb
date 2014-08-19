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

ActiveRecord::Schema.define(version: 20140818011838) do

  create_table "event_votes", force: true do |t|
    t.integer  "game_id"
    t.integer  "user_id"
    t.boolean  "vote"
    t.integer  "user_point_value"
    t.integer  "event_id"
    t.boolean  "has_voted"
    t.integer  "game_event_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "target_user_id"
  end

  create_table "game_events", force: true do |t|
    t.integer  "point_value"
    t.string   "data"
    t.integer  "game_id"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "target_user_id"
    t.integer  "yes_votes",      default: 1
  end

  add_index "game_events", ["game_id"], name: "index_game_events_on_game_id"
  add_index "game_events", ["user_id"], name: "index_game_events_on_user_id"

  create_table "games", force: true do |t|
    t.datetime "start_date"
    t.datetime "end_date"
    t.string   "name"
    t.string   "motto"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "league_id"
  end

  create_table "league_users", force: true do |t|
    t.integer  "user_id",    null: false
    t.integer  "league_id",  null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "league_users", ["league_id"], name: "index_league_users_on_league_id"
  add_index "league_users", ["user_id", "league_id"], name: "index_league_users_on_user_id_and_league_id", unique: true
  add_index "league_users", ["user_id"], name: "index_league_users_on_user_id"

  create_table "leagues", force: true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "scores", force: true do |t|
    t.integer  "points",     default: 0
    t.integer  "game_id",                null: false
    t.integer  "user_id",                null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "league_id"
  end

  add_index "scores", ["game_id", "user_id"], name: "index_scores_on_game_id_and_user_id", unique: true

  create_table "userposts", force: true do |t|
    t.string   "data"
    t.integer  "user_id"
    t.integer  "game_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "userposts", ["user_id", "created_at"], name: "index_userposts_on_user_id_and_created_at"

  create_table "users", force: true do |t|
    t.string   "name"
    t.string   "email"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "password_digest"
    t.string   "remember_token"
    t.boolean  "admin",           default: false
    t.boolean  "super_user",      default: false
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true
  add_index "users", ["remember_token"], name: "index_users_on_remember_token"

end
