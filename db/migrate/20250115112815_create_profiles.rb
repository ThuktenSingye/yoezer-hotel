# frozen_string_literal: true

# Migration to create the profiles table with polymorphic associations
class CreateProfiles < ActiveRecord::Migration[8.0]
  def change
    create_table :profiles do |t|
      t.string :first_name
      t.string :last_name
      t.string :cid_no
      t.integer :designation
      t.date :date_of_joining
      t.string :contact_no
      t.decimal :salary
      t.date :dob
      t.string :qualification
      t.references :profileable, polymorphic: true, null: false

      t.timestamps
    end
  end
end
