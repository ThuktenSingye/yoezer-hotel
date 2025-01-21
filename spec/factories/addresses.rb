# frozen_string_literal: true

FactoryBot.define do
  factory :address do
    dzongkhag { Faker::Address.state }
    gewog { Faker::Address.city }
    street_address { Faker::Address.street_address }
    address_type { :present }
    association :addressable, factory: %i[hotel profile]
  end

  trait :permanent_address do
    address_type { :permanent }
  end

  trait :invalid_params do
    dzongkhag { nil }
    gewog { nil }
    street_address { nil }
  end
end
