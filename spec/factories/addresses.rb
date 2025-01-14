FactoryBot.define do
  factory :address do
    dzongkhag { "MyString" }
    gewog { "MyString" }
    street_address { Faker::Address.street_address }
    address_type { :present }
    association :addressable, factory: :hotel
  end
  trait :invalid_params do
    dzongkhag { nil }
    gewog { nil }
    street_address { nil }
  end
end
