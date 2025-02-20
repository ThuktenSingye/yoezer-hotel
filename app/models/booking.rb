# frozen_string_literal: true

# Booking model
class Booking < ApplicationRecord
  belongs_to :guest
  belongs_to :room
  belongs_to :hotel
  accepts_nested_attributes_for :guest, allow_destroy: true

  enum :payment_status, { pending: 0, completed: 1, refunded: 2 }
  enum :status, { reserved: 0, booked: 1, cancelled: 2 }

  validates :checkin_date, :checkout_date, :num_of_adult, :num_of_children, presence: true

  def generate_confirmation_token
    self.confirmation_token = generate_unique_token
  end

  def generate_feedback_token
    self.feedback_token = generate_unique_token
  end

  def generate_unique_token(attempts = 5)
    retries ||= 0
    SecureRandom.urlsafe_base64(nil, false)
  rescue ActiveRecord::RecordNotUnique
    raise if (retries += 1) > attempts

    retry
  end
end
