# frozen_string_literal: true

FactoryBot.define do
  factory :facility do
    name { Faker::Name.name }
    association :hotel, factory: :hotel
  end

  trait :with_facility_image do
    after(:build) do |facility|
      facility.image.attach(
        Rack::Test::UploadedFile.new('spec/support/images/cat.jpg', 'image/jpeg')
      )
    end
  end

  trait :invalid_facility do
    name { nil }
  end
end
