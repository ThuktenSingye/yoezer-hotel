# frozen_string_literal: true

# Home Controller
class HomeController < ApplicationController
  before_action :hotel

  def show
    @amenities = @hotel.amenities.all
    @room_categories = @hotel.room_categories.limit(4)
    @offers = @hotel.offers.all
    @feedbacks = @hotel.feedbacks.limit(3)
  end

  private

  def hotel
    @hotel = find_hotel
  end

  def find_hotel
    if params[:location].present?
      Hotel.joins(:address).where('lower(replace(addresses.dzongkhag, \' \', \'\')) = ?',
                                  params[:location].to_s.downcase).first
    else
      # Default Hotel
      default_hotel_id = 1
      Hotel.find(default_hotel_id)
    end
  end
end
