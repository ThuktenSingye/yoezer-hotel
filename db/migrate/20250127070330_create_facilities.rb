# frozen_string_literal: true

# Migration to create room facility record
class CreateFacilities < ActiveRecord::Migration[8.0]
  def change
    create_table :facilities do |t|
      t.string :name
      t.references :hotel, null: false, foreign_key: true

      t.timestamps
    end
    add_index :facilities, :name, unique: true
  end
end
