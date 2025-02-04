# frozen_string_literal: true

# Migration to add a reference to the hotel model in the rooms table.
class AddHotelReferencesToRoom < ActiveRecord::Migration[8.0]
  def change
    add_reference :rooms, :hotel, foreign_key: true
  end
end
