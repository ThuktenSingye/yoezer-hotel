# frozen_string_literal: true

FactoryBot.define do
  factory :bed_type do
    name { Faker::Name.name }
    association :hotel, factory: :hotel
  end

  trait :invalid_bed_type do
    name { nil }
  end
end
