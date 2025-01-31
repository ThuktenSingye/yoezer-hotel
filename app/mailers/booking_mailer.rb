# frozen_string_literal: true

class BookingMailer < ApplicationMailer
  def confirmation_email(booking)
    @booking = booking
    # @guest_email = booking.guest.email
    # @hotel_email = booking.hotel.email
    @hotel_email = '02210232.cst@rub.edu.bt'
    @guest_email = 'thuktensingye2163@gmail.com'
    @confirmation_link = confirm_booking_admins_hotel_room_booking_url(
      hotel_id: booking.room.hotel.id,
      room_id: booking.room.id,
      id: booking.id,
      token: booking.confirmation_token
    )
    mail(to: @guest_email, subject: I18n.t('booking.confirmation-email-subject'), from: @hotel_email)
  end

  def booking_success_email(booking)
    @booking = booking
    @booking = booking
    # @guest_email = booking.guest.email
    # @hotel_email = booking.hotel.email
    @hotel_email = '02210232.cst@rub.edu.bt'
    @guest_email = 'thuktensingye2163@gmail.com'
    mail(to: @guest_email, subject: I18n.t('booking.success-email-subject'), from: @hotel_email)
  end

  def booking_update_email(booking)
    @booking = booking
    @booking = booking
    # @guest_email = booking.guest.email
    # @hotel_email = booking.hotel.email
    @hotel_email = '02210232.cst@rub.edu.bt'
    @guest_email = 'thuktensingye2163@gmail.com'
    mail(to: @guest_email, subject: I18n.t('booking.update-email-subject'), from: @hotel_email)
  end
end
