class Hotel < ApplicationRecord
  validates :name, presence: true
  validates :email, presence: true
  validates :contact_no, presence: true

  has_one :address, as: :addressable
  accepts_nested_attributes_for :address
  has_many :hotel_ratings, dependent: :destroy
end
