FactoryGirl.define do
  factory :offer do
    sequence(:name) { |n| "Offer #{n}" }
    #name      "Tomek Rusilko"
    #email     "tomek.rusilko@gmails.com"
    #sequence(:email) { |n| "person_#{n}@example.com" }
    #password  "foobar"
    #password_confirmation "foobar"

    #factory :admin do
    #  admin true
    #end
  end

  factory :quote do
    #content "Lorem ipsum"
    sequence(:name) { |n| "Quote #{n}" } #Faker::Lorem.sentence(5)
    offer
  end

  factory :income_variant do
    sequence(:number_of_participants) { |n| n }
    sequence(:price_per_participant)  { |n| n }
    quote
  end

  factory :cost_item do
    sequence(:name) { |n| "Cost item #{n}" }
    sequence(:single_cost) { |n| n*100 }
    sequence(:factor_type) { |n| %w(per_day per_person per_event)[0] }
    quote
  end
end