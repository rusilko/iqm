# encoding: utf-8
namespace :db do
    desc "Fill database with sample data"
    task populate: :environment do

      [ Offer, EventType, CostItemType, Event, Participant, EventParticipation, Company, User, Address, Order, OrderItem, Training, Product, Seat ].each(&:delete_all)

      # make_offers
      make_event_types
      # make_cost_item_types
      
      # make_events
      # make_participants
      # assign_participants_to_events

      # make_companies
      # make_clients
      # assign_client_to_companies
      # make_users
      # make_addresses_and_assign_to_customers
      # make_orders
      make_trainings
      # make_order_items
      # make_products
      # make_products
      # assign_clients_to_order_items


  end
end

def make_offers
  10.times do
    name = Faker::Company.name
    Offer.create!(name: name)
  end
end

def make_event_types
  %w(P2F P2P ITIL MoR).each do |n|
    EventType.create!(name: n)
  end
end

def make_cost_item_types
  types = ["trener", "sala", "materiały", "egzamin", "podręczniki", "przerwy kawowe",
           "obiady", "dojazd trenera", "noclegi", "dodatkowe koszty", "budżet ryzyka"].each do |n|
    CostItemType.create!(name: n)
  end
end

def make_events
  5.times do
    name = Faker::Lorem.sentence(1)
    Event.create!(name: name, date: Date.today, event_type_id: rand(0..3), city: Event.new.cities[rand(0..4)], price_per_participant: 2000 )
  end
end

def make_participants
  10.times do
    name = Faker::Name.name
    email = Faker::Internet.email(name)
    Participant.create!(name: name, email: email)
  end
end

def assign_participants_to_events
  offset = 0
  Event.all.each do |event|
    Participant.limit(2).offset(offset).each do |part|
      part.register_for_event!(event)
    end
    offset += 2
  end  
end

def make_companies
  3.times do
    name = Faker::Company.name
    phone_1 = Faker::PhoneNumber.phone_number
    phone_2 = Faker::PhoneNumber.cell_phone
    Company.create!(name: name, nip: "123", regon: "456", phone_1: phone_1, phone_2: phone_2)
  end
end

def make_clients
  5.times do
    name = Faker::Name.name
    email = Faker::Internet.email(name)
    phone_1 = Faker::PhoneNumber.phone_number
    phone_2 = Faker::PhoneNumber.cell_phone
    Client.create!(name: name, email: email, phone_1: phone_1, phone_2: phone_2)
  end
end

def assign_client_to_companies
  Company.find(1).employees << Client.find(1)
  Company.find(2).employees << Client.find(2)
  Company.find(2).employees << Client.find(3)
  Client.find(3).company_primary_contact = true
end

def make_users
  2.times do
    name = Faker::Name.name
    email = Faker::Internet.email(name)
    User.create!(email: email)
  end
end

def make_addresses_and_assign_to_customers
  16.times do
    line_1    = Faker::Address.street_address
    city      = Faker::Address.city
    postcode  = Faker::Address.postcode
    country   = Faker::Address.country
    Address.create!(line_1: line_1, city: city, postcode: postcode, country: country)
  end

  Customer.all.each_with_index do |c,i|
    a=[0,0]
    a = case i
      when 0 then [1,2]
      else [i*2+1,i*2+2]
    end
    c.addresses << Address.find(a[0])
    c.addresses << Address.find(a[1])
  end
end


def make_trainings
  5.times do
    name = Faker::Lorem.sentence(1)
    Training.create!(name: name, start_date: Date.today, end_date: Date.tomorrow, training_type_id: rand(3), city: Event.new.cities[rand(4)], price_per_person: 2000 )
  end
end

def make_orders
  Customer.all.each do |c|
    c.orders.create!(:date_placed => Time.now, :status => "new")
  end
end

def make_order_items
  t1 = Training.find(1)
  t2 = Training.find(2)
  oi1 = Order.find(1).order_items.create!(quantity: 1)
  oi2 = Order.find(2).order_items.create!(quantity: 3)
  oi3 = Order.find(3).order_items.create!(quantity: 4)
  t1.order_items << oi1
  t2.order_items << oi2
  t2.order_items << oi3
end

def make_products
 #
 #
end

def assign_clients_to_order_items
  oi1 = Order.find(1).order_items.first
  oi2 = Order.find(2).order_items.first
  oi1.participants << Client.find(1)
  oi2.participants << Client.find(1)
  oi2.participants << Client.find(2)
  oi2.participants << Client.find(3)
end

# def make_users
#   admin = User.create!(name: "Example User",
#                email: "example@railstutorial.org",
#                password: "foobar",
#                password_confirmation: "foobar")

#   admin.toggle!(:admin)
  
#   99.times do |n|
#     name  = Faker::Name.name
#     email = "example-#{n+1}@railstutorial.org"
#     password  = "password"
#     User.create!(name: name,
#                  email: email,
#                  password: password,
#                  password_confirmation: password)
#   end
# end

# def make_microposts
#   users = User.all(limit: 6)

#   50.times do
#     content = Faker::Lorem.sentence(5)
#     users.each { |u| u.microposts.create!(content: content) }
#   end
# end

# def make_relationships
#   users = User.all
#   user = users.first
#   followed_users  = users[2..50]
#   followers       = users[3..40]
#   followed_users.each { |followed| user.follow!(followed) }
#   followers.each      { |follower| follower.follow!(user)  }  
# end
