# frozen_string_literal: true

FactoryBot.define do
  factory :room_rating do
    rating { 1 }
    room { nil }
  end

  trait :invalid_room_rating do
    rating { nil }
  end
end
