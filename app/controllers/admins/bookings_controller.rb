# frozen_string_literal: true

module Admins
  # Booking controller for booking CRUD operation
  class BookingsController < AdminsController
    before_action :room, only: %i[new create]
    before_action :booking, only: %i[edit show update destroy]
    before_action :booking_service, only: %i[create]
    before_action :offers

    def index
      booking_query = BookingQuery.new(@hotel, params)
      @pagy, @bookings = pagy(booking_query.call, limit: 10)
      @checkout_pagy, @checkout_bookings = pagy(booking_query.search_by_checkout_date, limit: 10)
    end

    def show; end

    def new
      @booking = @hotel.bookings.new
      @booking.build_guest
    end

    def edit; end

    def create
      result = @booking_service.create_booking(booking_params, @offers)
      if result
        flash[:notice] = I18n.t('booking.create.success')
      else
        flash[:alert] = I18n.t('booking.create.error')
      end
      redirect_to admins_room_path(@room)
    end

    def update
      booking_service = Bookings::BookingService.new(@hotel, @booking.room, @booking)
      if booking_service.update_booking?(booking_params, @offers)
        flash[:notice] = I18n.t('booking.update.success')
        redirect_to admins_booking_path(@booking)
      else
        flash[:alert] = I18n.t('booking.update.error')
        render :edit, status: :unprocessable_entity
      end
    end

    def destroy
      if room_booked? && !payment_completed?
        flash[:alert] = I18n.t('booking.payment-missing')
      elsif @booking.destroy
        @booking.room.update(status: :available)
        flash[:notice] = I18n.t('booking.destroy.success')
      end

      redirect_to admins_bookings_path
    end

    private

    def room
      @room ||= @hotel.rooms.find(params[:room_id])
    end

    def booking
      @booking ||= @hotel.bookings.find(params[:id])
    rescue ActiveRecord::RecordNotFound
      flash[:alert] = I18n.t('booking.not-found')
      redirect_to admins_bookings_path
    end

    def booking_service
      @booking_service ||= Bookings::BookingService.new(@hotel, @room, @booking)
    end

    def room_booked?
      @booking.room.status == 'booked'
    end

    def payment_completed?
      @booking.payment_status == 'completed'
    end

    def room_booked_and_payment_completed?
      @booking.room.status == 'booked' && @booking.payment_status == 'completed'
    end

    def offers
      @offers = OfferQuery.new(@hotel).call
    end

    def booking_params
      params.require(:booking).permit(
        :checkin_date,
        :checkout_date,
        :total_amount,
        :confirmed,
        :num_of_adult,
        :num_of_children,
        :payment_status, :room_id,
        guest_attributes: %i[id first_name last_name contact_no email country region city hotel_id]
      )
    end
  end
end
