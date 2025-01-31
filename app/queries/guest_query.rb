# frozen_string_literal: true

# Search Query Class for Guests
class GuestQuery < BaseQuery
  def call
    guests = @hotel.guests
    guests = search_guest(guests) if @params[:query].present?

    ordered_records(guests)
  end

  private

  def search_guest(guests)
    query = "%#{@params[:query]}%"
    guests.where('first_name LIKE :query OR last_name LIKE :query OR email LIKE :query', query: query)
  end
end
