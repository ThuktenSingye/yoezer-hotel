# frozen_string_literal: true

# Guest Model
class Guest < ApplicationRecord
  belongs_to :hotel
  has_many :bookings, dependent: :destroy
  has_one :room_rating, dependent: :nullify
  has_one :hotel_rating, dependent: :nullify

  validates :first_name, :contact_no, :email, :country, :region, :city, presence: true
end
