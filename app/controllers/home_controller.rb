class HomeController < ApplicationController
  def index
    @amenities = Amenity.all
    @room_categories = RoomCategory.all.limit(4)
    @offers = Offer.all
    @feedbacks = Feedback.limit(3)
  end
end
