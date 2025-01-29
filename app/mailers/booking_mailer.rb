# frozen_string_literal: true

class BookingMailer < ApplicationMailer
  def confirmation_email(booking)
    @booking = booking
    # @guest_email = booking.guest.email
    # @hotel_email = booking.hotel.email
    @hotel_email = '02210232.cst@rub.edu.bt'
    @guest_email = 'thuktensingye2163@gmail.com'
    @confirmation_link = admins_hotel_room_booking_confirm_url(
      hotel_id: booking.room.hotel.id,
      room_id: booking.room.id,
      booking_id: booking.id,
      token: booking.confirmation_token
    )
    mail(to: @guest_email, subject: I18n.t('booking.email-subject'), from: @hotel_email)
  end
end
