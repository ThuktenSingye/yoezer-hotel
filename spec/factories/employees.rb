# frozen_string_literal: true

FactoryBot.define do
  factory :employee do
    email { Faker::Internet.email }
    after(:create) do |employee|
      employee.contract_files.attach(
        [
          Rack::Test::UploadedFile.new('spec/support/images/cat.jpg', 'image/jpeg'),
          Rack::Test::UploadedFile.new('spec/support/images/dog.jpg', 'image/jpeg')
        ]
      )
    end

    association :hotel, factory: :hotel
  end
end
