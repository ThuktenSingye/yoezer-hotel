# frozen_string_literal: true

FactoryBot.define do
  factory :guest do
    first_name { Faker::Name.first_name }
    last_name { Faker::Name.last_name }
    contact_no { Faker::Number.number(digits: 8).to_s }
    email { Faker::Internet.email }
    country { Faker::Address.country }
    region { Faker::Address.state }
    city { Faker::Address.city }
    association :hotel, factory: :hotel
  end

  trait :invalid_guest do
    first_name { nil }
    email { nil }
    contact_no { nil }
  end
end
