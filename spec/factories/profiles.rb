# frozen_string_literal: true

FactoryBot.define do
  factory :profile do
    first_name { Faker::Name.first_name }
    last_name { Faker::Name.last_name }
    cid_no { Faker::Number.number(digits: 11).to_s }
    designation { :manager }
    date_of_joining { Faker::Date.backward(days: 1) }
    contact_no { Faker::Number.number(digits: 8).to_s }
    salary { Faker::Number.decimal(l_digits: 5) }
    dob { Faker::Date.birthday(min_age: 18, max_age: 65) }
    qualification { Faker::Educator.degree }
    association :profileable, factory: :admin

    trait :with_invalid_params do
      first_name { nil }
      cid_no { nil }
      contact_no { nil }
    end

    trait :with_avatar do
      after(:build) do |profile|
        profile.avatar.attach(
          Rack::Test::UploadedFile.new('spec/support/images/cat.jpg', 'image/jpeg')
        )
      end
    end
  end
end
