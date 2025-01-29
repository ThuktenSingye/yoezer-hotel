# frozen_string_literal: true

class BookingService
  def initialize(hotel, room, booking, booking_params)
    @hotel = hotel
    @booking = booking
    @room = room
    @booking_params = booking_params
  end

  def create_booking
    return unless room_available?

    _guest = find_or_initialize_guest
    booking = build_booking

    if booking.save
      send_confirmation_email(booking)
      { valid: true }
    else
      false
    end
  end

  def confirm_token(id, token)
    @booking = @hotel.bookings.find_by(id: id, confirmation_token: token)
    if @booking && !@booking.confirmed?
      if validate_confirmation_link(@booking)
        { valid: true }
      else
        { valid: false, error: I18n.t('booking.expired') }
      end
    else
      { valid: false, error: I18n.t('booking.invalid') }
    end
  end

  private

  def room_available?
    @room.status.to_s == 'available'
  end

  def build_booking
    booking = @hotel.bookings.new(@booking_params)
    booking.room = @room
    booking.guest = @guest if @guest.present?
    booking.guest.hotel = @hotel if booking.guest.present?
    booking
  end

  def find_or_initialize_guest
    return if @hotel.guests.blank?

    @hotel.guests.find_or_initialize_by(email: @booking_params[:guest_attributes][:email]).tap do |guest|
      guest.hotel = @hotel if guest.new_record?
    end
  end

  def send_confirmation_email(booking)
    booking.update(confirmation_sent_at: Time.current, confirmation_expires_at: 24.hours.from_now)
    BookingMailer.confirmation_email(booking).deliver_later
  end

  def validate_confirmation_link(booking)
    if booking.confirmation_expires_at > Time.current
      booking.update(confirmed: true)
      true
    else
      false
    end
  end
end
