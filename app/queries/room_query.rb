# frozen_string_literal: true

# Room Query Class for searching and filtering rooms
class RoomQuery < BaseQuery
  def call
    rooms = @hotel.rooms
    rooms = filter_by_status(rooms) if @params[:status].present?
    rooms = filter_by_category(rooms) if @params[:room_category_id].present?
    rooms = filter_by_query(rooms) if @params[:query].present?

    ordered_records(rooms.includes(:room_ratings))
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

  def filter_by_query(rooms)
    query = @params[:query].strip

    if query.match?(/^\d+-\d+$/)
      min, max = query.split('-').map(&:to_i)
      rooms = rooms.where(base_price: min..max)
    elsif query.match?(/^\d+\+$/)
      min = query.to_i
      rooms = rooms.where(base_price: min..)
    end
    rooms
  end
end
