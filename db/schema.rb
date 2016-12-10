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

ActiveRecord::Schema.define(version: 20161210095958) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "activities", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "quantity"
    t.float    "market_price"
    t.integer  "create_time"
    t.integer  "deal_id"
    t.integer  "deal_item_id"
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
    t.float    "team_price"
  end

  create_table "deal_items", force: :cascade do |t|
    t.integer  "deal_id"
    t.string   "title_dealitem"
    t.string   "coupon_text1"
    t.string   "coupon_text2"
    t.string   "coupon_begin_time"
    t.string   "coupon_end_time"
    t.datetime "created_at",        null: false
    t.datetime "updated_at",        null: false
  end

  create_table "details", force: :cascade do |t|
    t.string   "title_deal"
    t.string   "title_desc"
    t.string   "title_city"
    t.integer  "deal_id"
    t.integer  "partner_id"
    t.float    "gpslat"
    t.float    "gpslong"
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
    t.integer  "deal_item_id"
  end

  create_table "stats", force: :cascade do |t|
    t.integer  "hits"
    t.integer  "total"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string   "strategy"
  end

  create_table "test_activities", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "quantity"
    t.float    "market_price"
    t.integer  "create_time"
    t.integer  "deal_id"
    t.integer  "deal_item_id"
    t.float    "team_price"
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
  end

end
