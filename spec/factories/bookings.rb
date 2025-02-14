# frozen_string_literal: true

FactoryBot.define do
  factory :booking do
    checkin_date { Faker::Date.backward(days: 14) }
    checkout_date { Faker::Date.forward(days: 14) }
    num_of_adult { Faker::Number.between(from: 1, to: 10) }
    num_of_children { Faker::Number.between(from: 1, to: 10) }
    payment_status { :completed }
    total_amount { Faker::Number.decimal(l_digits: 5) }
    confirmation_token { Faker::Internet.password }
    confirmation_expires_at { Faker::Date.forward(days: 1) }
    confirmed { false }
    association :guest, factory: :guest
    association :room, factory: :room
  end

  trait :invalid_booking do
    checkin_date { nil }
    checkout_date { nil }
    num_of_adult { nil }
    num_of_children { nil }
  end

  trait :active_booking do
    status { :booked }
  end

  trait :pending_payment do
    payment_status { :pending }
  end
end
