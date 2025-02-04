# frozen_string_literal: true

# Query class to search room facility by name
class FacilityQuery
  def initialize(hotel, params)
    @hotel = hotel
    @params = params
  end

  def call
    if @params[:query].present?
      search_facilities
    else
      search_all_facilities
    end
  end

  private

  def search_facilities
    @hotel.facilities.where('name LIKE ?', "%#{@params[:query]}%").order(created_at: :desc)
  end

  def search_all_facilities
    @hotel.facilities.order(created_at: :desc)
  end
end
