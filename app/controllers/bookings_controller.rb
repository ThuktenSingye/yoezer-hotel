# frozen_string_literal: true

# Booking controller for guest
class BookingsController < HomeController
  before_action :room
  before_action :offers
  before_action :booking_service, only: %i[create confirm update_confirmation]
  before_action :booking, only: %i[destroy confirm update_confirmation]

  def new
    @booking = @hotel.bookings.new
    @booking.build_guest
  end

  def create
    result = @booking_service.create_booking(booking_params, @offers)

    if result && result[:success]
      schedule_background_jobs(result[:booking])
      render json: { ok: true }, status: :ok
    else
      render json: { ok: false }, status: :unprocessable_entity
    end
  end

  def destroy
    if room_booked? && !payment_completed?
      flash[:alert] = I18n.t('booking.payment-missing')
    elsif @booking.destroy
      @booking.room.update(status: :available)
      flash[:notice] = I18n.t('booking.destroy.success')
    end

    redirect_to room_path(@room)
  end

  def confirm
    result = @booking_service.confirm_token(params[:id], params[:token])
    if result && @booking.confirmation_token == params[:token]
      render :confirm
    else
      flash[:alert] = I18n.t('booking.expired')
      redirect_to room_path(@room)
    end
  end

  def update_confirmation
    result = @booking_service.confirm_token_and_update(params[:id], params[:token])

    if result
      flash[:notice] = I18n.t('booking.confirmed')
    else
      flash[:alert] = I18n.t('booking.update.error')
    end
    redirect_to room_path(@room)
  end

  private

  def room
    @room ||= @hotel.rooms.find(params[:room_id])
  end

  def booking_service
    @booking_service ||= Bookings::BookingService.new(@hotel, @room, @booking)
  end

  def offers
    @offers = OfferQuery.new(@hotel).call
  end

  def booking
    @booking ||= @hotel.bookings.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    flash[:alert] = I18n.t('booking.not-found')
    redirect_to admins_hotel_bookings_path(hotel)
  end

  def room_booked?
    @booking.room.status == 'booked'
  end

  def payment_completed?
    @booking.payment_status == 'completed'
  end

  def schedule_background_jobs(booking)
    BookingCleanupWorker.perform_at(booking.confirmation_expires_at, booking.hotel.id, booking.id)
    FeedbackWorker.perform_at(3.minutes.from_now, booking.hotel.id, booking.id)
  end

  def booking_params
    params.require(:booking).permit(
      :checkin_date,
      :checkout_date,
      :confirmed,
      :num_of_adult,
      :num_of_children,
      :room_id,
      :payment_status,
      guest_attributes: %i[id first_name last_name contact_no email country region city hotel_id]
    )
  end
end
