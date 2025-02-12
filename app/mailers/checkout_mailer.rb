class CheckoutMailer < ApplicationMailer

  def checkout_email(booking)
    @booking = booking
    @guest_email = booking.guest.email
    @hotel_email = booking.hotel.email
    @feedback_link = feedbacks_url(
      subdomain: @booking.hotel.subdomain,
      token: @booking.feedback_token,
      booking_id: @booking.id
    )
    mail(to: @guest_email, subject: I18n.t('booking.confirmation-email-subject'), from: @hotel_email)
  end
end
