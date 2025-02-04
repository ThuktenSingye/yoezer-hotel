# frozen_string_literal: true

# Migration to create the room_categories table
class CreateRoomCategories < ActiveRecord::Migration[8.0]
  def change
    create_table :room_categories do |t|
      t.string :name

      t.timestamps
    end
  end
end
