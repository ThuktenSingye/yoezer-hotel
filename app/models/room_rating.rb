# frozen_string_literal: true

# Room Rating model
class RoomRating < ApplicationRecord
  belongs_to :room
  belongs_to :guest

  validates :rating, numericality: { only_integer: true, in: 0..5 }, presence: true
end
