FactoryGirl.define do
  factory :offer do
    sequence(:name) { |n| "Offer #{n}" }
  end

  factory :quote do
    sequence(:name) { |n| "Quote #{n}" }
    offer
  end

  factory :income_variant do
    number_of_participants 10
    price_per_participant  1500
    quote
  end

  factory :cost_item do
    sequence(:name) { |n| "Cost item #{n}" }
    single_cost 100
    factor_type "per_day"
    quote
  end
end