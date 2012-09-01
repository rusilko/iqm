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
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20120831212649) do

  create_table "cost_items", :force => true do |t|
    t.integer  "quote_id"
    t.string   "name"
    t.integer  "single_cost"
    t.string   "factor_type"
    t.integer  "total_cost"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  create_table "income_variants", :force => true do |t|
    t.integer  "quote_id"
    t.integer  "number_of_participants"
    t.integer  "price_per_participant"
    t.datetime "created_at",             :null => false
    t.datetime "updated_at",             :null => false
    t.boolean  "currently_chosen"
  end

  create_table "offers", :force => true do |t|
    t.string   "name"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "quotes", :force => true do |t|
    t.integer  "offer_id"
    t.string   "name"
    t.string   "event_type"
    t.integer  "number_of_days"
    t.datetime "created_at",     :null => false
    t.datetime "updated_at",     :null => false
  end

end
