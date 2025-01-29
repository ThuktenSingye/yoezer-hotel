# frozen_string_literal: true

# Guest Model
class Guest < ApplicationRecord
  belongs_to :hotel
  has_many :bookings, dependent: :destroy

  validates :first_name, :contact_no, :email, :country, :region, :city, presence: true
end
