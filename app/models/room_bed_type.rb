# frozen_string_literal: true

# Many-to-Many relation model between Room and Bed Type model
class RoomBedType < ApplicationRecord
  belongs_to :room
  belongs_to :bed_type

  validates :num_of_bed, presence: true, numericality: { only_integer: true }
end
