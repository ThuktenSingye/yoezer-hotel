# frozen_string_literal: true

# Migration to associate admin with hotel model
class AddHotelToAdmin < ActiveRecord::Migration[8.0]
  def change
    add_reference :admins, :hotel, foreign_key: true
  end
end
