# frozen_string_literal: true

FactoryBot.define do
  factory :room_category do
    name { Faker::Lorem.word }
  end

  trait :invalid_room_category_params do
    name { nil }
  end
end
