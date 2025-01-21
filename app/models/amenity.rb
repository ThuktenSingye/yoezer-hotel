# frozen_string_literal: true

# Polymorphic model for amenities with image attachment
class Amenity < ApplicationRecord
  belongs_to :amenityable, polymorphic: true
  has_one_attached :image

  validates :name, presence: true
end
