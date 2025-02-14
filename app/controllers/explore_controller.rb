# frozen_string_literal: true

# Explore Controller
class ExploreController < HomeController
  def index
    @hotels_feature = @hotel.hotel_galleries.all
  end
end
