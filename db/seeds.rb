# frozen_string_literal: true

# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end

# db/seeds.rb

require 'faker'

hotel = Hotel.create(name: "Yoezer Hotel", description: "cdscsdcds", email: "02210232.cst@rub.edu.bt", contact_no: "17293224", subdomain: "yoezerhotel")
Address.create(dzongkhag: Faker::Address.state, gewog: Faker::Address.city, street_address: Faker::Address.street_address, addressable: hotel)

# Create an employee with nested profile and addresses
admin = Admin.create!(email: 'admin@example.com', password: 'admin1234', password_confirmation: 'admin1234', hotel: hotel)
profile = Profile.create!(first_name: Faker::Name.first_name , last_name: "Singye", contact_no: "17293224", cid_no: "11102004718", profileable: admin)
Address.create(dzongkhag: Faker::Address.state, gewog: Faker::Address.city, street_address: Faker::Address.street_address, address_type: :present, addressable: profile)
Address.create(dzongkhag: Faker::Address.state, gewog: Faker::Address.city, street_address: Faker::Address.street_address, address_type: :permanent, addressable: profile)
