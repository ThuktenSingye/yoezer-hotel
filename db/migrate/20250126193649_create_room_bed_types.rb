# frozen_string_literal: true

# Migration to create room bed type model
class CreateRoomBedTypes < ActiveRecord::Migration[8.0]
  def change
    create_table :room_bed_types do |t|
      t.references :room, null: false, foreign_key: true
      t.references :bed_type, null: false, foreign_key: true

      t.timestamps
    end
  end
end
