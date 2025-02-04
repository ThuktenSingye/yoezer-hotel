# frozen_string_literal: true

# Search Query class for guest
class GuestQuery
  def initialize(hotel, params)
    @hotel = hotel
    @params = params
  end

  def call
    if @params[:query].present?
      search_guest
    else
      search_all_guest
    end
  end

  private

  def search_guest
    query = "%#{@params[:query]}%"
    @hotel.guests.where('first_name LIKE :query OR last_name LIKE :query OR email LIKE :query',
                        query: query).order(created_at: :desc)
  end

  def search_all_guest
    @hotel.guests.order(created_at: :desc)
  end
end
