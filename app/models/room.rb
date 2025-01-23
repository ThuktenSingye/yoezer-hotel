# frozen_string_literal: true

class Room < ApplicationRecord
  belongs_to :room_category
  belongs_to :hotel
  has_one_attached :primary_image
  has_many_attached :images

  enum :status, { booked: 0, available: 1, maintenance: 2 }

  validates :room_number, :base_price, :max_no_adult, :max_no_children, :status, presence: true
  validates :room_number, uniqueness: { case_sensitive: false }
end
