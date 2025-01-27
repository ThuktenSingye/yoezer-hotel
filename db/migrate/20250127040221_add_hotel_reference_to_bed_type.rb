# frozen_string_literal: true

# Migration to add hotel references to Bed Type model
class AddHotelReferenceToBedType < ActiveRecord::Migration[8.0]
  def change
    add_reference :bed_types, :hotel, foreign_key: true
  end
end
