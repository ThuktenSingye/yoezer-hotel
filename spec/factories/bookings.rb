FactoryBot.define do
  factory :booking do
    checkin_date { Faker::Date.backward(days: 14) }
    checkout_date { Faker::Date.backward(days: 14) }
    num_of_adult { Faker::Number.between(from: 1, to: 10) }
    num_of_children { Faker::Number.between(from: 1, to: 10) }
    payment_status { :pending }
    total_amount { Faker::Number.decimal(l_digits: 5) }
    confirmation_token { Faker::Internet.password }
    confirmed { false }
    association :guest, factory: :guest
    association :hotel, factory: :hotel
  end

  trait :invalid_booking do
    checkin_date { nil }
    checkout_date { nil }
    num_of_adult { nil }
    num_of_children { nil }
  end
end
