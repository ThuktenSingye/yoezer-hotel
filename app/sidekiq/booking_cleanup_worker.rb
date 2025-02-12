# frozen_string_literal: true

# Worker class to destroy bookings at checkout date
class BookingCleanupWorker
  include Sidekiq::Job

  sidekiq_options queue: 'booking_cleanup_queue', retry: false

  def perform(hotel_id, booking_id)
    hotel = Hotel.find(hotel_id)
    booking = hotel.bookings.find(booking_id)
    return unless booking

    if booking.room.status != 'booked'
      booking.destroy
      booking.room&.update(status: :available)
    end
  rescue ActiveRecord::RecordNotFound
    Rails.logger.info("Booking with ID #{booking_id} not found.")
  end
end
