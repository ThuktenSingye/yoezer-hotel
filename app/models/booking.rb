# frozen_string_literal: true

# Booking model
class Booking < ApplicationRecord
  belongs_to :guest, dependent: :destroy
  belongs_to :room
  belongs_to :hotel
  accepts_nested_attributes_for :guest, allow_destroy: true

  enum :payment_status, { pending: 0, completed: 1, refunded: 2 }

  validates :checkin_date, :checkout_date, :num_of_adult, :num_of_children, presence: true

  def generate_confirmation_token(attempts = 5)
    retries ||= 0
    self.confirmation_token = SecureRandom.urlsafe_base64(nil, false)
  rescue ActiveRecord::RecordNotUnique
    raise if (retries += 1) > attempts

    # Rails.logger.warn("Collision detected for confirmation token, attempt number #{retries}")
    retry
  end
end
