# frozen_string_literal: true

module Bookings
  # Booking mailing class
  class BookingMailerService
    def self.send_confirmation_email(booking)
      booking.update(
        confirmation_sent_at: Time.current,
        confirmation_expires_at: 24.hours.from_now
      )
      BookingMailer.confirmation_email(booking).deliver_later(queue: 'mailers')
    end

    def self.send_booking_update_email(booking)
      BookingMailer.booking_update_email(booking).deliver_later(queue: 'mailers')
    end
  end
end
