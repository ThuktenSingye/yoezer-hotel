# frozen_string_literal: true

# Booking business logic class
class BookingService
  def initialize(hotel, room, booking)
    @hotel = hotel
    @room = room
    @booking = booking
  end

  def create_booking(booking_params)
    return false unless booking_date_present?(booking_params)

    booking_params = booking_params.merge(
      total_amount: calculate_total_amount(booking_params[:checkin_date],
                                           booking_params[:checkout_date], @room)
    )
    booking = build_booking(booking_params)
    save_and_send_email(booking)
  end

  def update_booking?(booking_params)
    return false unless booking_date_present?(booking_params)

    booking = assign_association(booking_params)
    previous_attributes = store_previous_attributes(booking)

    if update_booking_and_room(booking, booking_params)
      check_and_send_update_email(booking, previous_attributes)
      return true
    end
    false
  end

  def confirm_token(id, token)
    booking = @hotel.bookings.find_by(id: id, confirmation_token: token)
    return { valid: false, error: I18n.t('booking.invalid-confirmation') } unless booking && !booking.confirmed?

    validate_confirmation_link(booking) ? { valid: true } : { valid: false, error: I18n.t('booking.expired') }
  end

  private

  def build_booking(booking_params)
    booking = @hotel.bookings.build(booking_params)
    booking.room = @room
    booking.guest.hotel = @hotel
    booking.generate_confirmation_token
    booking
  end

  def assign_association(booking_params)
    @booking.room&.update(status: :available)
    @booking.room ||= Room.find(booking_params[:room_id]) if booking_params[:room_id].present?
    @booking.guest.hotel ||= @hotel if @booking.guest.present?
    @booking
  end

  def save_and_send_email(booking)
    if booking.save
      booking.room.update(status: :reserved)
      send_confirmation_email(booking) and true
    end
    false
  end

  def send_confirmation_email(booking)
    booking.update(
      confirmation_sent_at: Time.current,
      confirmation_expires_at: 24.hours.from_now
    )
    BookingMailer.confirmation_email(booking).deliver_later(queue: 'mailers')
  end

  def send_booking_update_email(booking)
    BookingMailer.booking_update_email(booking).deliver_later(queue: 'mailers')
  end

  def validate_confirmation_link(booking)
    booking.confirmation_expires_at > Time.current
  end

  def booking_date_present?(booking_params)
    booking_params[:checkin_date].present? && booking_params[:checkout_date].present?
  end

  def calculate_total_amount(checkin_date, checkout_date, room)
    checkin_date = Date.parse(checkin_date) if checkin_date.present?
    checkout_date = Date.parse(checkout_date) if checkout_date.present?

    room_price_per_night = room.base_price
    total_amount = (checkout_date - checkin_date).to_i * room_price_per_night
    total_amount.positive? ? total_amount : room_price_per_night
  end

  def booking_attributes_changed?(booking, previous_checkin_date, previous_checkout_date, previous_room_id)
    booking.checkin_date != previous_checkin_date ||
      booking.checkout_date != previous_checkout_date ||
      booking.room_id != previous_room_id
  end

  def store_previous_attributes(booking)
    {
      checkin_date: booking.checkin_date,
      checkout_date: booking.checkout_date,
      room_id: booking.room_id
    }
  end

  def update_booking_and_room(booking, booking_params)
    if booking.update(booking_params)
      booking.room.update(status: :booked)
      total_amount = calculate_total_amount(booking_params[:checkin_date], booking_params[:checkout_date], booking.room)
      booking.update(total_amount: total_amount)
      return true
    end
    false
  end

  def check_and_send_update_email(booking, previous_attributes)
    if booking_attributes_changed?(booking, previous_attributes[:checkin_date], previous_attributes[:checkout_date],
                                   previous_attributes[:room_id])
      send_booking_update_email(booking)
    end
  end
end
