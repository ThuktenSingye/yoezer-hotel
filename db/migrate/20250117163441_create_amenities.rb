# frozen_string_literal: true

# Migration to create the amenities table with a polymorphic association
class CreateAmenities < ActiveRecord::Migration[8.0]
  def change
    create_table :amenities do |t|
      t.string :name
      t.references :amenityable, polymorphic: true, null: false

      t.timestamps
    end
  end
end
