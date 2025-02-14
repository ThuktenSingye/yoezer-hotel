# frozen_string_literal: true

# Worker class to destroy bookings at checkout date
class BookingCleanupWorker
  include Sidekiq::Job

  sidekiq_options queue: :booking_cleanup_queue

  def perform(*_args)
    expired_bookings = Booking.where(confirmation_expires_at: ...Time.current)
    return if expired_bookings.blank?

    expired_bookings.each do |booking|
      booking.destroy
      booking.room.update(status: :available)
    end
  end
end
