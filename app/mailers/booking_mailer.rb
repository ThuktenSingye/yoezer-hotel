# frozen_string_literal: true

# Booking Mailer class
class BookingMailer < ApplicationMailer
  def confirmation_email(booking)
    @booking = booking
    @guest_email = booking.guest.email
    @hotel_email = booking.hotel.email
    @confirmation_link = confirm_room_booking_url(
      subdomain: booking.hotel.subdomain,
      room_id: booking.room.id,
      id: booking.id,
      token: booking.confirmation_token
    )
    begin
      @booking = Booking.find(@booking.id)
      mail(to: @guest_email, subject: I18n.t('booking.confirmation-email-subject'), from: @hotel_email)
    rescue ActiveRecord::RecordNotFound
      Rails.logger.warn("Booking with ID #{booking.id} not found.  Skipping confirmation email.")
    end
  end

  def booking_success_email(booking)
    @booking = booking
    @guest_email = booking.guest.email
    @hotel_email = booking.hotel.email
    mail(to: @guest_email, subject: I18n.t('booking.success-email-subject'), from: @hotel_email)
  end

  def booking_update_email(booking)
    @booking = booking
    @guest_email = booking.guest.email
    @hotel_email = booking.hotel.email
    mail(to: @guest_email, subject: I18n.t('booking.update-email-subject'), from: @hotel_email)
  end
end
