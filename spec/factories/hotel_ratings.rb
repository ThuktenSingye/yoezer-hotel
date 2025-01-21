# frozen_string_literal: true

FactoryBot.define do
  factory :hotel_rating do
    rating { 1 }
    hotel { nil }
  end
end
