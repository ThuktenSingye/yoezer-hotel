# frozen_string_literal: true

# Query class to search room facilities by name
class FacilityQuery < BaseQuery
  def call
    facilities = @hotel.facilities
    facilities = search_facilities(facilities) if @params[:query].present?

    ordered_records(facilities)
  end

  private

  def search_facilities(facilities)
    facilities.where('name LIKE ?', "%#{@params[:query]}%")
  end
end
