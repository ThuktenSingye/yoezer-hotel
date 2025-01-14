FactoryBot.define do
  factory :hotel do
    name { Faker::Name.name }
    email { Faker::Internet.email }
    contact_no { Faker::Number.number(digits: 8) }
    description { Faker::Lorem.sentence }
  end
end
