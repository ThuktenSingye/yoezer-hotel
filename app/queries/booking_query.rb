# frozen_string_literal: true

# Query class for booking
class BookingQuery < BaseQuery
  def call
    bookings = @hotel.bookings
    bookings = filter_by_status(bookings) if @params[:status].present?
    bookings = search_booking(bookings) if @params[:query].present?
    ordered_records(bookings)
  end

  private

  def filter_by_status(bookings)
    if Room.statuses.key?(@params[:status])
      bookings.joins(:room).where(rooms: { status: Room.statuses[@params[:status]] })
    else
      bookings
    end
  end

  def search_booking(bookings)
    query = "%#{@params[:query]}%"

    bookings.joins(:guest, room: :room_category).where(
      'guests.first_name ILIKE :query OR guests.last_name ILIKE :query OR
     rooms.room_number ILIKE :query OR room_categories.name ILIKE :query',
      query: query
    )
  end

  def ordered_records(bookings)
    bookings.order(
      Arel.sql(
        "CASE
        WHEN checkin_date = '#{Time.zone.today}' THEN 0
        WHEN checkout_date = '#{Time.zone.today}' THEN 1
        ELSE 2
      END"
      )
    )
  end
end
