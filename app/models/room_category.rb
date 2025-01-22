# frozen_string_literal: true

# Room Category model
class RoomCategory < ApplicationRecord
  validates :name, presence: true, uniqueness: true
end
