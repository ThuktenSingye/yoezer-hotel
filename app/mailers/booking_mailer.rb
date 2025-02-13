# frozen_string_literal: true

# Booking Mailer class
class BookingMailer < ApplicationMailer
  def confirmation_email(hotel_id, booking_id)
    @hotel = Hotel.find(hotel_id)
    @booking = @hotel.bookings.find(booking_id)
    return unless @booking

    @confirmation_link = confirm_room_booking_url(
      subdomain: booking.hotel.subdomain,
      room_id: booking.room.id,
      id: booking.id,
      token: booking.confirmation_token
    )
    @booking =  @hotel.bookings.find(booking.id)
    mail(to: @booking.guest.email, subject: I18n.t('booking.confirmation-email-subject'), from: @hotel.email)
  end

  def booking_success_email(hotel_id, booking_id)
    @hotel = Hotel.find(hotel_id)
    @booking = @hotel.bookings.find(booking_id)
    return unless @booking

    mail(to: @booking.guest.email, subject: I18n.t('booking.success-email-subject'), from: @hotel.email)
  end

  def booking_update_email(hotel_id, booking_id)
    @hotel = Hotel.find(hotel_id)
    @booking = @hotel.bookings.find(booking_id)
    return unless @booking

    mail(to: @booking.guest.email, subject: I18n.t('booking.update-email-subject'), from: @hotel.email)
  end
end
