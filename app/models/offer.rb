# frozen_string_literal: true

# Represents offer model for a hotel
class Offer < ApplicationRecord
  belongs_to :hotel
  has_one_attached :image

  validates :title, :description, :start_time, :end_time, presence: true
  validates :discount, numericality: { in: 0..100 }
end
