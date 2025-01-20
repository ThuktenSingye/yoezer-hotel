class Hotel < ApplicationRecord
  validates :name, presence: true
  validates :email, presence: true
  validates :contact_no, presence: true

  has_many :address, as: :addressable
  accepts_nested_attributes_for :address
  has_many :hotel_ratings, dependent: :destroy
  has_many :amenities, as: :amenityable
  has_many :feedbacks
end
