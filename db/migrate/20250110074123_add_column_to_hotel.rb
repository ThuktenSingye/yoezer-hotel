# frozen_string_literal: true

# Migration to add a description column to the hotels table
class AddColumnToHotel < ActiveRecord::Migration[8.0]
  def change
    add_column :hotels, :description, :text
  end
end
