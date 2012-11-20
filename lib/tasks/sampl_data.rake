# encoding: utf-8
namespace :db do
    desc "Fill database with sample data"
    task populate: :environment do

      [Offer,EventType,CostItemType,Event,Participant,EventParticipation].each(&:delete_all)

      make_offers
      make_event_types
      make_cost_item_types
      make_events
      make_participants
      assign_participants_to_events
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
