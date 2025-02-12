# frozen_string_literal: true

# Hotel model with validations and association
class Hotel < ApplicationRecord
  include RatingCalculator
  validates :name, :email, :contact_no, presence: true

  has_many :address, as: :addressable, dependent: :destroy
  accepts_nested_attributes_for :address
  has_many :hotel_ratings, dependent: :destroy
  has_many :amenities, as: :amenityable, dependent: :destroy
  has_many :feedbacks, dependent: :destroy
  has_many :hotel_galleries, dependent: :destroy
  has_many :offers, dependent: :destroy
  has_many :admins, dependent: :destroy
  has_many :room_categories, dependent: :destroy
  has_many :rooms, dependent: :destroy
  has_many :bed_types, dependent: :destroy
  has_many :facilities, dependent: :destroy
  has_many :employees, dependent: :destroy
  has_many :guests, dependent: :destroy
  has_many :bookings, dependent: :destroy
  has_many_attached :images, dependent: :destroy

  def generate_feedback_token
    self.feedback_token = GenerateToken.generate_unique_token
  end
end
