# frozen_string_literal: true

# Query class for booking
class BookingQuery < BaseQuery
  def call
    bookings = @hotel.bookings
    bookings = filter_by_status(bookings) if @params[:status].present?
    bookings = filter_by_checkin_date(bookings) if @params[:checkin_date].present?
    bookings = filter_by_checkout_date(bookings) if @params[:checkout_date].present?
    bookings = search_booking(bookings) if @params[:query].present?
    ordered_records(bookings)
  end

  def search_by_checkout_date
    @hotel.bookings.where(checkout_date: Time.zone.today)
  end

  private

  def filter_by_checkin_date(bookings)
    if @params[:checkin_date].present?
      checkin_date = Date.parse(@params[:checkin_date])
      bookings = bookings.where(checkin_date: checkin_date)
    end

    bookings
  end

  def filter_by_checkout_date(bookings)
    if @params[:checkout_date].present?
      checkout_date = Date.parse(@params[:checkout_date])
      bookings = bookings.where(checkout_date: checkout_date)
    end

    bookings
  end

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
end
