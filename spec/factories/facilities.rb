FactoryBot.define do
  factory :facility do
    name { Faker::Name.name }
    association :hotel, factory: :hotel
  end

  trait :invalid_facility do
    name { nil }
  end
end

