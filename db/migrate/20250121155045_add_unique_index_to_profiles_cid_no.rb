# frozen_string_literal: true

# Migration to add a unique index to the cid_no column in profiles table
class AddUniqueIndexToProfilesCidNo < ActiveRecord::Migration[8.0]
  def change
    add_index :profiles, :cid_no, unique: true
  end
end
