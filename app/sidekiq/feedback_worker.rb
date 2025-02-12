# frozen_string_literal: true

# Feedback Worker Job
class FeedbackWorker
  include Sidekiq::Job

  sidekiq_options queue: 'default'

  def perform(hotel_id, booking_id)
    hotel = Hotel.find(hotel_id)
    booking = hotel.bookings.find(booking_id)

    return unless booking

    booking.update(feedback_expires_at: 1.hour.from_now)
    CheckoutMailer.checkout_email(booking).deliver_later(queue: 'mailers')
  end
end
