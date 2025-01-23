# frozen_string_literal: true

# Room Category model
class RoomCategory < ApplicationRecord
  belongs_to :hotel

  validates :name, presence: true, uniqueness: true
end
