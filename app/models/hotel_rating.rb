# frozen_string_literal: true

# Represents a rating model for a hotel
class HotelRating < ApplicationRecord
  belongs_to :hotel
  belongs_to :guest

  validates :rating, numericality: { only_integer: true, in: 0..5 }, presence: true
end
