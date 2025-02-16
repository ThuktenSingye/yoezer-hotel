# frozen_string_literal: true

# Represents a rating model for a hotel
class HotelRating < ApplicationRecord
  belongs_to :hotel
  belongs_to :guest
end
