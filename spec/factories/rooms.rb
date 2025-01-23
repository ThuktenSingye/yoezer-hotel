# frozen_string_literal: true

FactoryBot.define do
  factory :room do
    room_number { Faker::Number.unique.number(digits: 3).to_s }
    floor_number { Faker::Number.number(digits: 1) }
    status { 1 }
    description { Faker::Lorem.sentence }
    max_no_adult { Faker::Number.number(digits: 2) }
    max_no_children { Faker::Number.number(digits: 2) }
    base_price { Faker::Number.decimal(l_digits: 5, r_digits: 2) }
    association :hotel, factory: :hotel
  end

  trait :invalid_room_params do
    room_number { nil }
    status { nil }
    base_price { nil }
    max_no_adult { nil }
    max_no_children { nil }
  end

  trait :with_room_image do
    after(:build) do |room|
      room.images.attach(
        [
          Rack::Test::UploadedFile.new('spec/support/images/cat.jpg', 'image/jpeg'),
          Rack::Test::UploadedFile.new('spec/support/images/dog.jpg', 'image/jpeg')
        ]
      )
    end
  end
  # trait :with_room_primary_image do
  #   after(:build) do |room|
  #     room.primary_image.attach(
  #         Rack::Test::UploadedFile.new('spec/support/images/cat.jpg', 'image/jpeg')
  #     )
  #   end
  # end
end
