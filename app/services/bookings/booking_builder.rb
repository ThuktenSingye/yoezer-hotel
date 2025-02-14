# frozen_string_literal: true

module Bookings
  # Booking Builder Class
  class BookingBuilder
    def initialize(hotel, room, booking_params)
      @hotel = hotel
      @room = room
      @booking_params = booking_params
    end

    def build
      booking = @hotel.bookings.build(@booking_params)
      booking.room = @room
      booking.guest.hotel = @hotel
      booking.generate_confirmation_token
      booking
    end
  end
end
