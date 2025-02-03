# frozen_string_literal: true

# Hotel model with validations and association
class Hotel < ApplicationRecord
  validates :name, :email, :contact_no, presence: true

  has_many :address, as: :addressable, dependent: :destroy
  accepts_nested_attributes_for :address
  has_many :hotel_ratings, dependent: :destroy
  has_many :amenities, as: :amenityable, dependent: :destroy
  has_many :feedbacks, dependent: :destroy
  has_many :hotel_galleries, dependent: :destroy
  has_many :offers, dependent: :destroy
  has_many :admins, dependent: :destroy
end
