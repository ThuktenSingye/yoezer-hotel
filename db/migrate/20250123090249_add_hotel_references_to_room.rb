# frozen_string_literal: true

class AddHotelReferencesToRoom < ActiveRecord::Migration[8.0]
  def change
    add_reference :rooms, :hotel, foreign_key: true
  end
end
