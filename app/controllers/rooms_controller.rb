class RoomsController < ApplicationController
  def index

    @hotel = Hotel.first
    # @rooms = Room.includes(:room_category).all
    @pagy , @rooms = pagy(RoomQuery.new(@hotel, params).call, limit: 6 )
    @room_category = RoomCategory.all
    @offers = Offer.all
  end

  def show
    @room ||= Room.find(params[:id])
    @offers = Offer.all
  end
end
