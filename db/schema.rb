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

ActiveRecord::Schema.define(version: 20160225070137) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "apps", force: :cascade do |t|
    t.string   "name"
    t.string   "description"
    t.string   "apikey"
    t.integer  "user_id"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  add_index "apps", ["user_id"], name: "index_apps_on_user_id", using: :btree

  create_table "creators", force: :cascade do |t|
    t.string   "name"
    t.string   "password_digest"
    t.string   "email"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
  end

  create_table "positions", force: :cascade do |t|
    t.string   "address"
    t.float    "longitude"
    t.float    "latitude"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "restaurants", force: :cascade do |t|
    t.string   "name"
    t.string   "message"
    t.integer  "rating"
    t.integer  "position_id"
    t.integer  "creator_id"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  add_index "restaurants", ["creator_id"], name: "index_restaurants_on_creator_id", using: :btree
  add_index "restaurants", ["position_id"], name: "index_restaurants_on_position_id", using: :btree

  create_table "restaurants_tags", id: false, force: :cascade do |t|
    t.integer "restaurant_id", null: false
    t.integer "tag_id",        null: false
  end

  add_index "restaurants_tags", ["restaurant_id", "tag_id"], name: "index_restaurants_tags_on_restaurant_id_and_tag_id", using: :btree
  add_index "restaurants_tags", ["tag_id", "restaurant_id"], name: "index_restaurants_tags_on_tag_id_and_restaurant_id", using: :btree

  create_table "tags", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "users", force: :cascade do |t|
    t.string   "name"
    t.string   "password_digest"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
  end

end
