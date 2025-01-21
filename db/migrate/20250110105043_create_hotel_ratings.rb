# frozen_string_literal: true

# Migration to create the hotel_ratings table
class CreateHotelRatings < ActiveRecord::Migration[8.0]
  def change
    create_table :hotel_ratings do |t|
      t.integer :rating, default: 0
      t.references :hotel, null: false, foreign_key: true

      t.timestamps
    end
  end
end
