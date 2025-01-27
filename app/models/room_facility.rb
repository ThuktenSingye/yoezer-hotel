# frozen_string_literal: true

# Room Facility junction model
class RoomFacility < ApplicationRecord
  belongs_to :room
  belongs_to :facility
end
