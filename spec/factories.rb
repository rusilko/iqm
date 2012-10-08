FactoryGirl.define do
  factory :offer do
    sequence(:name) { |n| "Offer #{n}" }
  end

  factory :quote do
    sequence(:name) { |n| "Quote #{n}" }
    vat "23"
    event_type
    offer
  end

  factory :income_variant do
    number_of_participants 10
    price_per_participant  1500
    quote
  end

  factory :cost_item do
    single_cost 100
    factor_type "per_day"
    vat "23"
    quote
    cost_item_type
  end

  factory :event_type do
    sequence(:name) { |n| "Event Type #{n}" }
  end

  factory :cost_item_type do
    sequence(:name) { |n| "Cost Item #{n}" }
  end
end