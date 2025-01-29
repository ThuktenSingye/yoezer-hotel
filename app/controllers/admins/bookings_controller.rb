# frozen_string_literal: true

module Admins
  class BookingsController < AdminsController
    before_action :hotel
    before_action :room
    before_action :booking, only: %i[show]
    before_action :booking_service, only: %i[create confirm_booking]

    def index; end

    def show; end

    def new
      @booking = @hotel.bookings.new
      @booking.build_guest
    end

    def create
      result = @booking_service.create_booking

      if result
        flash[:notice] = I18n.t('booking.create.success')
      else
        flash[:alert] = I18n.t('booking.create.error')
      end
      redirect_to admins_hotel_room_path(@hotel, @room)
    end

    def confirm_booking
      result = @booking_service.confirm_token(params[:id], params[:token])

      if result[:valid]
        flash[:notice] = I18n.t('booking.confirmed')
      else
        flash[:alert] = result[:error]
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

    def booking_service
      @booking_service ||= BookingService.new(@hotel, @room, @booking, booking_params)
    end

    def booking_params
      params.require(:booking).permit(:checkin_date, :checkout_date, :total_amount, :confirmed, :num_of_adult, :num_of_children,
                                      :payment_status, guest_attributes: %i[id first_name last_name contact_no email country region city])
    end
  end
end
