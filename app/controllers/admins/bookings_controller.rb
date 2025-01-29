# frozen_string_literal: true

module Admins
  class BookingsController < AdminsController
    before_action :hotel
    before_action :room
    before_action :booking, only: %i[show]

    def index; end

    def show; end

    def new
      @booking = @hotel.bookings.new
      @booking.build_guest
    end

    def create
      return unless room_available?

      @guest = find_or_initialize_guest
      @booking = build_booking
      if @booking.save
        send_confirmation_email(@booking)
        flash[:notice] = I18n.t('booking.create.success')
      else
        flash.now[:alert] = I18n.t('booking.create.error')
      end
      redirect_to admins_hotel_room_path(@hotel, @room)
    end

    private

    def room
      @room ||= Room.find(params[:room_id])
    end

    def hotel
      @hotel ||= Hotel.find(params[:hotel_id])
    end

    def booking
      @booking ||= Booking.find(params[:id])
    rescue ActiveRecord::RecordNotFound
      flash[:alert] = I18n.t('booking.not-found')
      redirect_to admins_hotel_room_path(@hotel, @room)
    end

    def room_available?
      @room.status.to_s == 'available'
    end

    def find_or_initialize_guest
      return if @hotel.guests.blank?

      @hotel.guests.find_or_initialize_by(email: params[:guest][:email]).tap do |guest|
        guest.hotel = @hotel if guest.new_record?
      end
    end

    def build_booking
      booking = @hotel.bookings.new(booking_params)
      booking.room = @room
      booking.guest = @guest if @guest.present?
      booking.guest.hotel = @hotel if booking.guest.present?
      booking
    end

    def confirm_booking
      @booking = @hotel.bookings.find_by(params[:id], confirmation_token: params[:token])
      if @booking && !@booking.confirmed?
        validate_confirmation_link(@booking)
      else
        flash[:alert] = I18n.t('booking.invalid')
      end
      redirect_to admins_hotel_room_path(@hotel, @booking.room)
    end

    def send_confirmation_email(booking)
      booking.update(confirmation_sent_at: Time.current, confirmation_expires_at: 24.hours.from_now)
      BookingMailer.confirmation_email(booking).deliver_later
    end

    def validate_confirmation_link(booking)
      if booking.confirmation_expires_at > Time.current
        booking.update(confirmed: true)
        flash[:notice] = I18n.t('booking.confirmed')
      else
        flash[:alert] = I18n.t('booking.expired')
      end
    end

    def booking_params
      params.require(:booking).permit(:checkin_date, :checkout_date, :total_amount, :confirmed, :num_of_adult, :num_of_children,
                                      :payment_status, guest_attributes: %i[id first_name last_name contact_no email country region city])
    end
  end
end
