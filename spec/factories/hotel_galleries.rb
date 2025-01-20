FactoryBot.define do
  factory :hotel_gallery do
    name { Faker::Name.unique.name }
    description { Faker::Lorem.sentence }
    association :hotel, factory: :hotel
  end

  trait :with_hotel_image do
    after(:build) do |hotel_gallery|
      hotel_gallery.images.attach(
        Rack::Test::UploadedFile.new("spec/support/images/cat.jpg", "image/jpeg"),
        )
    end
  end
  trait :invalid_hotel_gallery do
    name { nil }
    description { nil }
  end
end
