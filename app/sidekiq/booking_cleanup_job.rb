# frozen_string_literal: true

# Worker class to destroy bookings at checkout date
class BookingCleanupJob
  include Sidekiq::Job

  sidekiq_options queue: :booking_cleanup_queue

  def perform(*_args)
    expired_bookings = Booking.where(checkout_date: ..Time.current)
    expired_bookings.destroy_all if expired_bookings.present?
  end
end
