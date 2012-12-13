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

ActiveRecord::Schema.define(:version => 20121206183853) do

  create_table "addresses", :force => true do |t|
    t.string   "line_1"
    t.string   "postcode"
    t.string   "city"
    t.boolean  "default_sending"
    t.boolean  "default_billing"
    t.integer  "addressable_id"
    t.string   "addressable_type"
    t.datetime "created_at",       :null => false
    t.datetime "updated_at",       :null => false
  end

  create_table "clients", :force => true do |t|
    t.string   "name",       :null => false
    t.string   "email",      :null => false
    t.string   "phone_1"
    t.string   "phone_2"
    t.integer  "company_id"
    t.string   "position"
    t.boolean  "confirmed"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "clients", ["email"], :name => "index_clients_on_email"
  add_index "clients", ["name"], :name => "index_clients_on_name"

  create_table "companies", :force => true do |t|
    t.string   "name",       :null => false
    t.string   "email"
    t.string   "phone_1"
    t.string   "phone_2"
    t.string   "nip"
    t.string   "regon"
    t.boolean  "confirmed"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "companies", ["email"], :name => "index_companies_on_email"
  add_index "companies", ["name"], :name => "index_companies_on_name"

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

  create_table "event_type_products", :force => true do |t|
    t.integer  "event_type_id"
    t.integer  "product_id"
    t.datetime "created_at",    :null => false
    t.datetime "updated_at",    :null => false
  end

  create_table "event_types", :force => true do |t|
    t.string   "name"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

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

  create_table "order_items", :force => true do |t|
    t.integer  "quantity"
    t.integer  "order_id"
    t.integer  "productable_id"
    t.string   "productable_type"
    t.datetime "created_at",       :null => false
    t.datetime "updated_at",       :null => false
  end

  add_index "order_items", ["order_id"], :name => "index_order_items_on_order_id"
  add_index "order_items", ["productable_id", "productable_type"], :name => "index_order_items_on_productable_id_and_productable_type"
  add_index "order_items", ["productable_id"], :name => "index_order_items_on_productable_id"

  create_table "orders", :force => true do |t|
    t.string   "status"
    t.date     "date_placed"
    t.integer  "customer_id"
    t.string   "customer_type"
    t.integer  "coordinator_id"
    t.datetime "created_at",     :null => false
    t.datetime "updated_at",     :null => false
  end

  add_index "orders", ["customer_id", "customer_type"], :name => "index_orders_on_customer_id_and_customer_type"
  add_index "orders", ["date_placed"], :name => "index_orders_on_date_placed"
  add_index "orders", ["status"], :name => "index_orders_on_status"

  create_table "products", :force => true do |t|
    t.string   "name"
    t.integer  "price"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

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

  create_table "seats", :force => true do |t|
    t.integer  "client_id"
    t.integer  "order_item_id"
    t.integer  "training_id"
    t.datetime "created_at",    :null => false
    t.datetime "updated_at",    :null => false
  end

  add_index "seats", ["client_id", "order_item_id"], :name => "index_seats_on_client_id_and_order_item_id", :unique => true
  add_index "seats", ["client_id", "training_id"], :name => "index_seats_on_client_id_and_training_id", :unique => true
  add_index "seats", ["client_id"], :name => "index_seats_on_client_id"
  add_index "seats", ["order_item_id"], :name => "index_seats_on_order_item_id"

  create_table "trainings", :force => true do |t|
    t.string   "name"
    t.date     "start_date"
    t.date     "end_date"
    t.string   "city"
    t.integer  "price_per_person"
    t.integer  "training_type_id"
    t.datetime "created_at",       :null => false
    t.datetime "updated_at",       :null => false
  end

  add_index "trainings", ["city"], :name => "index_trainings_on_city"
  add_index "trainings", ["name"], :name => "index_trainings_on_name"
  add_index "trainings", ["start_date"], :name => "index_trainings_on_start_date"
  add_index "trainings", ["training_type_id"], :name => "index_trainings_on_training_type_id"

end
