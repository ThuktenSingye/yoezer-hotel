# frozen_string_literal: true

# Model representing a hotel room with attributes
class Room < ApplicationRecord
  include RatingCalculable
  belongs_to :room_category
  belongs_to :hotel
  has_one_attached :image
  has_many_attached :images
  has_many :room_ratings, dependent: :destroy

  enum :status, { booked: 0, available: 1, maintenance: 2 }

  validates :room_number, :base_price, :max_no_adult, :max_no_children, :status, presence: true
  validates :room_number, uniqueness: { case_sensitive: false }
end
