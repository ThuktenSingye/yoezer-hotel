# frozen_string_literal: true

FactoryBot.define do
  factory :amenity do
    name { Faker::Name.name }
    association :amenityable, factory: :hotel
  end

  trait :with_amenity_image do
    after(:build) do |amenity|
      amenity.image.attach(
        Rack::Test::UploadedFile.new('spec/support/images/cat.jpg', 'image/jpeg')
      )
    end
  end
  trait :invalid_amenity do
    name { nil }
  end
end
