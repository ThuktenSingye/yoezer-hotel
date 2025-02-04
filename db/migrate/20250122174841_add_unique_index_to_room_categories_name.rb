# frozen_string_literal: true

# Migration to add a unique index to the name column in the room_categories table.
class AddUniqueIndexToRoomCategoriesName < ActiveRecord::Migration[8.0]
  def change
    add_index :room_categories, :name, unique: true
  end
end
