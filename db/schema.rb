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

ActiveRecord::Schema.define(:version => 20121220084029) do

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

  add_index "event_type_products", ["event_type_id", "product_id"], :name => "index_event_type_products_on_event_type_id_and_product_id", :unique => true
  add_index "event_type_products", ["event_type_id"], :name => "index_event_type_products_on_event_type_id"
  add_index "event_type_products", ["product_id"], :name => "index_event_type_products_on_product_id"

  create_table "event_type_trainings", :force => true do |t|
    t.integer  "event_type_id"
    t.integer  "training_id"
    t.datetime "created_at",    :null => false
    t.datetime "updated_at",    :null => false
  end

  add_index "event_type_trainings", ["event_type_id", "training_id"], :name => "index_event_type_trainings_on_event_type_id_and_training_id", :unique => true
  add_index "event_type_trainings", ["event_type_id"], :name => "index_event_type_trainings_on_event_type_id"
  add_index "event_type_trainings", ["training_id"], :name => "index_event_type_trainings_on_training_id"

  create_table "event_types", :force => true do |t|
    t.string   "name"
    t.text     "introduction"
    t.text     "description"
    t.integer  "default_price_per_person"
    t.integer  "default_number_of_days"
    t.datetime "created_at",               :null => false
    t.datetime "updated_at",               :null => false
  end

  add_index "event_types", ["name"], :name => "index_event_types_on_name"

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

  create_table "segments", :force => true do |t|
    t.string   "name"
    t.integer  "number_of_hours"
    t.text     "scenario"
    t.integer  "event_type_id"
    t.integer  "default_lineup"
    t.datetime "created_at",      :null => false
    t.datetime "updated_at",      :null => false
  end

  add_index "segments", ["event_type_id"], :name => "index_segments_on_event_type_id"

  create_table "training_products", :force => true do |t|
    t.integer  "training_id"
    t.integer  "product_id"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  add_index "training_products", ["product_id"], :name => "index_training_products_on_product_id"
  add_index "training_products", ["training_id", "product_id"], :name => "index_training_products_on_training_id_and_product_id", :unique => true
  add_index "training_products", ["training_id"], :name => "index_training_products_on_training_id"

  create_table "training_segments", :force => true do |t|
    t.integer  "segment_id"
    t.integer  "training_id"
    t.string   "name"
    t.text     "scenario"
    t.integer  "number_of_hours"
    t.datetime "start_time"
    t.integer  "lineup"
    t.datetime "created_at",      :null => false
    t.datetime "updated_at",      :null => false
  end

  add_index "training_segments", ["segment_id", "training_id"], :name => "index_training_segments_on_segment_id_and_training_id", :unique => true
  add_index "training_segments", ["segment_id"], :name => "index_training_segments_on_segment_id"
  add_index "training_segments", ["training_id"], :name => "index_training_segments_on_training_id"

  create_table "trainings", :force => true do |t|
    t.string   "name"
    t.string   "city"
    t.text     "introduction"
    t.text     "description"
    t.integer  "price_per_person"
    t.datetime "start_time"
    t.integer  "number_of_days"
    t.integer  "number_of_hours"
    t.boolean  "exemplary",        :default => false
    t.datetime "created_at",                          :null => false
    t.datetime "updated_at",                          :null => false
  end

  add_index "trainings", ["city"], :name => "index_trainings_on_city"
  add_index "trainings", ["name"], :name => "index_trainings_on_name"
  add_index "trainings", ["start_time"], :name => "index_trainings_on_start_time"

  create_table "users", :force => true do |t|
    t.string   "email"
    t.string   "password_digest"
    t.datetime "created_at",      :null => false
    t.datetime "updated_at",      :null => false
  end

end
