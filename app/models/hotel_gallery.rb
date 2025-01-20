class HotelGallery < ApplicationRecord
  belongs_to :hotel
  has_many_attached :images

  validates :name, presence: true
  validates :description, presence: true
end
