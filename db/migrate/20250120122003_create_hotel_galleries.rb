# frozen_string_literal: true

# Migration to create the hotel_galleries table
class CreateHotelGalleries < ActiveRecord::Migration[8.0]
  def change
    create_table :hotel_galleries do |t|
      t.string :name
      t.text :description
      t.references :hotel, null: false, foreign_key: true

      t.timestamps
    end
  end
end
