# frozen_string_literal: true

# Model representing a hotel room with attributes
class Room < ApplicationRecord
  include RatingCalculator
  belongs_to :room_category
  belongs_to :hotel
  has_one_attached :image
  has_many_attached :images
  has_many :room_ratings, dependent: :destroy
  has_many :room_bed_types, dependent: :destroy
  has_many :bed_types, through: :room_bed_types, dependent: :destroy
  has_many :room_facilities, dependent: :destroy
  has_many :facilities, through: :room_facilities, dependent: :destroy
  has_one :booking, dependent: :destroy

  MAX_RATING = 5

  enum :status, { reserved: 0, booked: 1, available: 2, maintenance: 3 }

  validates :room_number, :base_price, :max_no_adult, :max_no_children, :status, presence: true
  validates :room_number, uniqueness: { case_sensitive: false }
end
