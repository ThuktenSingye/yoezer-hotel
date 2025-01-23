# frozen_string_literal: true

class AddHotelReferencesToRoomCategory < ActiveRecord::Migration[8.0]
  def change
    add_reference :room_categories, :hotel, foreign_key: true
  end
end
