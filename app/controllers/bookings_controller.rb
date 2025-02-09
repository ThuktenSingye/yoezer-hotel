class BookingsController < HomeController
  before_action :room, only: %i[new create confirm destroy update_confirmation]
  before_action :offers
  before_action :booking_service, only: %i[create confirm update_confirmation]
  before_action :booking, only: %i[destroy confirm update_confirmation]


  def index; end

  def new; end

  def create
    result = @booking_service.create_booking(booking_params, @offers)
    if result
      flash[:notice] = I18n.t('booking.create.success')
    else
      flash[:alert] = I18n.t('booking.create.error')
    end
    redirect_to room_path(@room)
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

    if result[:valid] && @booking.confirmation_token == params[:token]
      render :confirm
    else
      flash[:alert] = I18n.t('booking.invalid-confirmation')
      redirect_to admins_hotel_room_path(@hotel, @room)
    end
  end

  def update_confirmation
    result = @booking_service.confirm_token(params[:id], params[:token])

    if result[:valid]
      confirm_booking_and_redirect
    else
      flash[:alert] = result[:error]
      redirect_to room_path(@room)
    end
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

  def confirm_booking_and_redirect
    @booking.update(confirmed: true)
    @booking.room.update(status: :booked)
    BookingMailer.booking_success_email(@booking).deliver_later(queue: 'mailers')
    flash[:notice] = I18n.t('booking.confirmed')
    redirect_to room_path(@room)
  end


  def booking_params
    params.require(:booking).permit(
      :checkin_date,
      :checkout_date,
      :confirmed,
      :num_of_adult,
      :num_of_children,
      :room_id,
      guest_attributes: %i[id first_name last_name contact_no email country region city hotel_id]
    )
  end
end
