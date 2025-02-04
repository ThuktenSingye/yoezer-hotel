# frozen_string_literal: true

# Amenity Query Class for searching and filtering amenities
class AmenityQuery < BaseQuery
  def call
    amenities = @hotel.amenities
    amenities = search_amenities(amenities) if @params[:query].present?
    ordered_records(amenities)
  end

  private

  def search_amenities(amenities)
    amenities.where('name LIKE ?', "%#{@params[:query]}%")
  end
end
