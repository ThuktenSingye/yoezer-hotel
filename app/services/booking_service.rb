# frozen_string_literal: true

# Booking business logic class
class BookingService
  def initialize(hotel, room, booking)
    @hotel = hotel
    @room = room
    @booking = booking
  end

  def create_booking(booking_params, offers)
    return false unless booking_date_present?(booking_params)

    booking_params = booking_params.merge(
      total_amount: calculate_total_amount(booking_params[:checkin_date],
                                           booking_params[:checkout_date], @room, offers)
    )
    booking = build_booking(booking_params)
    save_and_send_email(booking)
  end

  def update_booking?(booking_params, offers)
    return false unless booking_date_present?(booking_params)

    booking = assign_association(booking_params)
    previous_attributes = store_previous_attributes(booking)

    if update_booking_and_room(booking, booking_params, offers)
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
    @booking.room ||= Room.find(booking_params[:room_id]) if booking_params[:room_id].present?
    @booking.guest.hotel ||= @hotel if @booking.guest.present?
    @booking
  end

  def save_and_send_email(booking)
    if booking.save
      booking.room.update(status: :reserved)
      send_confirmation_email(booking)
      return true
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

  def calculate_total_amount(checkin_date, checkout_date, room, offers)
    checkin_date = parse_date(checkin_date)
    checkout_date = parse_date(checkout_date)

    total_price = calculate_total_price(checkin_date, checkout_date, room.base_price, offers)
    total_price.positive? ? total_price : room.base_price
  end

  def parse_date(date_string)
    return date_string if date_string.is_a?(Date)
    Date.parse(date_string) if date_string.present?
  end

  def calculate_total_price(checkin_date, checkout_date, base_price, offers)
    total_discount = 0
    (checkin_date...checkout_date).each do |date|
      applicable_offer = find_applicable_offer(date, offers)
      total_discount += calculate_discount(base_price, applicable_offer.discount) if applicable_offer
    end
    total_price = (checkout_date - checkin_date).to_i * base_price
    total_price - total_discount
  end

  def find_applicable_offer(date, offers)
    offers.find do |offer|
      offer_start_date = parse_date(offer.start_time)
      offer_end_date = parse_date(offer.end_time)

      date >= offer_start_date && date <= offer_end_date
    end
  end

  def calculate_discount(base_price, discount_percentage)
    (discount_percentage * base_price) / 100.0
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

  def update_booking_and_room(booking, booking_params, offers)
    if booking.update(booking_params)
      total_amount = calculate_total_amount(booking_params[:checkin_date], booking_params[:checkout_date],
                                            booking.room, offers)
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
