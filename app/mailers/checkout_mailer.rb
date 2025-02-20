# frozen_string_literal: true

# Checkout Mailer Class
class CheckoutMailer < ApplicationMailer
  def checkout_email(booking)
    @booking = booking
    @guest_email = booking.guest.email
    @hotel_email = booking.hotel.email
    @feedback_link = feedbacks_url(
      token: @booking.feedback_token,
      booking_id: @booking.id
    )
    mail(to: @guest_email, subject: I18n.t('feedback.email_subject'), from: @hotel_email)
  end
end
