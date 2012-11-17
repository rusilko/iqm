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

ActiveRecord::Schema.define(:version => 20121116215924) do

  create_table "cost_item_types", :force => true do |t|
    t.string   "name"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "cost_items", :force => true do |t|
    t.integer  "quote_id"
    t.string   "factor_type"
    t.datetime "created_at",                                      :null => false
    t.datetime "updated_at",                                      :null => false
    t.string   "vat"
    t.decimal  "single_cost",       :precision => 8, :scale => 2
    t.integer  "cost_item_type_id"
  end

  create_table "event_participations", :force => true do |t|
    t.integer  "event_id"
    t.integer  "participant_id"
    t.datetime "created_at",     :null => false
    t.datetime "updated_at",     :null => false
  end

  add_index "event_participations", ["event_id", "participant_id"], :name => "index_event_participations_on_event_id_and_participant_id", :unique => true
  add_index "event_participations", ["event_id"], :name => "index_event_participations_on_event_id"
  add_index "event_participations", ["participant_id"], :name => "index_event_participations_on_participant_id"

  create_table "event_types", :force => true do |t|
    t.string   "name"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "events", :force => true do |t|
    t.string   "name"
    t.date     "date"
    t.decimal  "price_per_participant", :precision => 8, :scale => 2
    t.integer  "event_type_id"
    t.string   "city"
    t.datetime "created_at",                                          :null => false
    t.datetime "updated_at",                                          :null => false
  end

  add_index "events", ["city"], :name => "index_events_on_city"
  add_index "events", ["date"], :name => "index_events_on_date"
  add_index "events", ["name"], :name => "index_events_on_name"

  create_table "income_variants", :force => true do |t|
    t.integer  "quote_id"
    t.integer  "number_of_participants"
    t.datetime "created_at",                                                              :null => false
    t.datetime "updated_at",                                                              :null => false
    t.boolean  "currently_chosen",                                     :default => false
    t.decimal  "price_per_participant",  :precision => 8, :scale => 2
  end

  create_table "offers", :force => true do |t|
    t.string   "name"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "participants", :force => true do |t|
    t.string   "name"
    t.string   "email"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "participants", ["email"], :name => "index_participants_on_email", :unique => true
  add_index "participants", ["name"], :name => "index_participants_on_name"

  create_table "quotes", :force => true do |t|
    t.integer  "offer_id"
    t.string   "name"
    t.integer  "number_of_days"
    t.datetime "created_at",                       :null => false
    t.datetime "updated_at",                       :null => false
    t.date     "event_date"
    t.string   "vat",            :default => "23"
    t.integer  "event_type_id"
  end

end
