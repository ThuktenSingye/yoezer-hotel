# frozen_string_literal: true

# Room Query Class for searching and filtering rooms
class RoomQuery < BaseQuery
  def call
    rooms = @hotel.rooms.where(status: :available)
    rooms = filter_by_status(rooms) if @params[:status].present?
    rooms = filter_by_category(rooms) if @params[:room_category_id].present?
    rooms = filter_by_price(rooms) if @params[:query].present?

    ordered_records(rooms.includes(:room_ratings))
  end

  private

  def filter_by_status(rooms)
    if @hotel.rooms.statuses.key?(@params[:status])
      rooms.where(status: @hotel.rooms.statuses[@params[:status]])
    else
      rooms
    end
  end

  def filter_by_category(rooms)
    rooms.where(room_category_id: @params[:room_category_id])
  end

  def filter_by_price(rooms)
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
