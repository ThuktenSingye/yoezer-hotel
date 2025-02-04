# frozen_string_literal: true

# Migration to create the rooms table with necessary fields
class CreateRooms < ActiveRecord::Migration[8.0]
  def change
    create_table :rooms do |t|
      t.string :room_number
      t.integer :floor_number
      t.integer :status
      t.decimal :base_price, precision: 10, scale: 2
      t.text :description
      t.integer :max_no_adult
      t.integer :max_no_children
      t.references :room_category, null: false, foreign_key: true

      t.timestamps
    end
    add_index :rooms, :room_number, unique: true
  end
end
