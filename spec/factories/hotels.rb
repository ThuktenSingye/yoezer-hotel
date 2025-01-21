# frozen_string_literal: true

FactoryBot.define do
  factory :hotel do
    name { Faker::Name.name }
    email { Faker::Internet.email }
    contact_no { Faker::Number.number(digits: 8).to_s }
    description { Faker::Lorem.sentence }

    trait :invalid_hotel_params do
      name { nil }
      email { nil }
      contact_no { nil }
      description { nil }
    end

    trait :with_address do
      dzongkhag { Faker::Address.state }
      gewog { Faker::Address.city }
      street_address { Faker::Address.street_address }
    end
  end
end
