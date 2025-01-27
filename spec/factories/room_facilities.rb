# frozen_string_literal: true

FactoryBot.define do
  factory :room_facility do
    association :room, factory: :room
    association :facility, factory: :facility
  end
end
