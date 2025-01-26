class RoomBedType < ApplicationRecord
  belongs_to :room
  belongs_to :bed_type
end
