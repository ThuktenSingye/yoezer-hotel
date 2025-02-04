# frozen_string_literal: true

# Migration to add a reference to the hotel in the room_categories table
class AddHotelReferencesToRoomCategory < ActiveRecord::Migration[8.0]
  def change
    add_reference :room_categories, :hotel, foreign_key: true
  end
end
