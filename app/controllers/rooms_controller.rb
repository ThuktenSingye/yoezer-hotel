# frozen_string_literal: true

# Room Controller for User
class RoomsController < HomeController
  before_action :room, only: [:show]
  before_action :offers

  def index
    @pagy, @rooms = pagy(RoomQuery.new(@hotel, params).call, limit: 6)
    @room_category = @hotel.room_categories.all
  end

  def show
    @booking = @hotel.bookings.new
    @booking.build_guest
  end

  private

  def room
    @room ||= @hotel.rooms.find(params[:id])
  end

  def offers
    @offers ||= @hotel.offers.all
  end
end
