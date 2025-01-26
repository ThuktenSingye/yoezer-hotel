# frozen_string_literal: true

# Migration to create room rating model
class CreateRoomRatings < ActiveRecord::Migration[8.0]
  def change
    create_table :room_ratings do |t|
      t.integer :rating, default: 0
      t.references :room, null: false, foreign_key: true

      t.timestamps
    end
  end
end
