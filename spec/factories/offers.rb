FactoryBot.define do
  factory :offer do
    title { Faker::Lorem.sentence   }
    description { Faker::Lorem.paragraph }
    start_time { Faker::Time.backward(days: 30) }
    end_time { Faker::Time.forward(days: 30) }
    discount { Faker::Number.decimal(l_digits: 3, r_digits: 2) }
    association :hotel, factory: :hotel
  end

  trait :with_offer_image do
    after(:build) do |offer|
      offer.image.attach(
        Rack::Test::UploadedFile.new("spec/support/images/cat.jpg", "image/jpeg"),
        )
    end
  end

  trait :invalid_offer_params do
    title { nil }
    description { nil }
    start_time { null }
    end_time { null }
  end
end
