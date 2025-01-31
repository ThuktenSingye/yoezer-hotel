class BookingCleanupJob
  include Sidekiq::Job

  sidekiq_options queue: :booking_cleanup_queue

  def perform(*args)
    expired_bookings = Booking.where('checkout_date <= ?', Time.current)
    expired_bookings.destroy_all if expired_bookings.present?
  end
end
