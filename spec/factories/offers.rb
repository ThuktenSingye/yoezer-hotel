# frozen_string_literal: true

FactoryBot.define do
  factory :offer do
    title { Faker::Lorem.sentence }
    description { Faker::Lorem.paragraph }
    start_time { Faker::Date.backward(days: 14) }
    end_time { Faker::Date.forward(days: 14) }
    discount { Faker::Number.between(from: 0, to: 100) }
    association :hotel, factory: :hotel
  end

  trait :with_offer_image do
    after(:build) do |offer|
      offer.image.attach(
        Rack::Test::UploadedFile.new('spec/support/images/cat.jpg', 'image/jpeg')
      )
    end
  end

  trait :invalid_offer_params do
    title { nil }
    description { nil }
    start_time { nil }
    end_time { nil }
  end
end
