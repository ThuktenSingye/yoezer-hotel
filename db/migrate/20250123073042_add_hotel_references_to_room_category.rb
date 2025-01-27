# frozen_string_literal: true
# Add Hotel References to Room Category model
class AddHotelReferencesToRoomCategory < ActiveRecord::Migration[8.0]
  def change
    add_reference :room_categories, :hotel, foreign_key: true
  end
end
