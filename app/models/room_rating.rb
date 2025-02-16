# frozen_string_literal: true

# Room Rating model
class RoomRating < ApplicationRecord
  belongs_to :room
  belongs_to :guest
end
