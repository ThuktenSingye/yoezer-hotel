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
    @hotel ||= find_hotel
  end

  def find_hotel
    if request.subdomain.present?
      Hotel.find_by(subdomain: request.subdomain) || default_hotel
    else
      default_hotel
    end
  end

  def default_hotel
    default_hotel_id = 3
    Hotel.find(default_hotel_id)
  end
end
