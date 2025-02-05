# frozen_string_literal: true

# Room Category model
class RoomCategory < ApplicationRecord
  belongs_to :hotel
  has_one_attached :image
  has_many :rooms, dependent: :nullify

  validates :name, presence: true, uniqueness: true
end
