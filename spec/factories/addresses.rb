FactoryBot.define do
  factory :address do
    dzongkhag { "MyString" }
    gewog { "MyString" }
    street_address { "MyText" }
    address_type { 1 }
    addressable { nil }
  end
end
