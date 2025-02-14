# frozen_string_literal: true

# Booking Mailer class
class BookingMailer < ApplicationMailer
  def confirmation_email(hotel_id, booking_id)
    @hotel = Hotel.find(hotel_id)
    @booking = @hotel.bookings.find(booking_id)
    @confirmation_link = confirm_room_booking_url(
      room_id: @booking.room.id,
      id: @booking.id,
      token: @booking.confirmation_token
    )
    mail(to: @booking.guest.email, subject: I18n.t('booking.confirmation-email-subject'), from: @hotel.email)
  rescue ActiveRecord::RecordNotFound
    Rails.logger.info "Couldn't  find Booking Record"
  end

  def booking_success_email(hotel_id, booking_id)
    @hotel = Hotel.find(hotel_id)
    @booking = @hotel.bookings.find(booking_id)

    mail(to: @booking.guest.email, subject: I18n.t('booking.success-email-subject'), from: @hotel.email)
  rescue ActiveRecord::RecordNotFound
    Rails.logger.info "Couldn't find Booking Record"
  end

  def booking_update_email(hotel_id, booking_id)
    @hotel = Hotel.find(hotel_id)
    @booking = @hotel.bookings.find(booking_id)

    mail(to: @booking.guest.email, subject: I18n.t('booking.update-email-subject'), from: @hotel.email)
  rescue ActiveRecord::RecordNotFound
    Rails.logger.info "Couldn't find Booking Record"
  end
end
