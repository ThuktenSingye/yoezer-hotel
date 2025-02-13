# frozen_string_literal: true

# Home Controller
class HomeController < ApplicationController
  def show
    @amenities = @hotel.amenities.all
    @room_categories = @hotel.room_categories.limit(4)
    @offers = @hotel.offers.all
    @feedbacks = @hotel.feedbacks.limit(3)
  end
end
