# frozen_string_literal: true

# Amenity query
class AmenityQuery
  def initialize(hotel, params)
    @hotel = hotel
    @params = params
  end

  def call
    if @params[:query].present?
      search_amenities
    else
      all_amenities
    end
  end

  private

  def search_amenities
    @hotel.amenities.where('name LIKE ?', "%#{@params[:query]}%").order(created_at: :desc)
  end

  def all_amenities
    @hotel.amenities.order(created_at: :desc)
  end
end
