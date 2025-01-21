# frozen_string_literal: true

FactoryBot.define do
  factory :feedback do
    name { Faker::Name.name }
    email { Faker::Internet.email }
    feedback { Faker::Lorem.sentence }
    association :hotel, factory: :hotel
  end
end
