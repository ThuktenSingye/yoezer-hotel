class Amenity < ApplicationRecord
  belongs_to :amenityable, polymorphic: true
  has_one_attached :image

  validates :name, presence: true
end
