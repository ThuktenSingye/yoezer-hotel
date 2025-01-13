FactoryBot.define do
  factory :admin_profile, class: 'Admin::Profile' do
    first_name { "MyString" }
    last_name { "MyString" }
    cid_no { "MyString" }
    designation { 1 }
    date_of_joining { "2025-01-13" }
    contact_no { "MyString" }
    salary { "9.99" }
    dob { "2025-01-13" }
    qualification { "MyString" }
    association :profileable, factory: :admin
  end
end
