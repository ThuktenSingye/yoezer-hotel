# frozen_string_literal: true

# Room query class for searching and filtering
class RoomQuery
  def initialize(hotel, params)
    @hotel = hotel
    @params = params
  end

  def call
    rooms = @hotel.rooms
    rooms = filter_by_status(rooms) if @params[:status].present?
    rooms = filter_by_category(rooms) if @params[:room_category_id].present?
    rooms = search_by_query(rooms) if @params[:query].present?

    rooms.includes(:room_ratings).order(created_at: :desc)
  end

  private

  def filter_by_status(rooms)
    if Room.statuses.key?(@params[:status])
      rooms.where(status: Room.statuses[@params[:status]])
    else
      rooms.none
    end
  end

  def filter_by_category(rooms)
    rooms.where(room_category_id: @params[:room_category_id])
  end

  def search_by_query(rooms)
    query = "%#{@params[:query]}%"
    rooms.where('room_number::text LIKE :query OR base_price::text LIKE :query', query: query)
  end
end
