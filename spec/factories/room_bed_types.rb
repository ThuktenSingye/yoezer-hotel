# frozen_string_literal: true

FactoryBot.define do
  factory :room_bed_type do
    association :room, factory: :room
    association :bed_type, factory: :bed_type
    num_of_bed { Faker::Number.between(from: 1, to: 10) }
  end

  trait :invalid_room_bed_type do
    num_of_bed { nil }
  end
end
