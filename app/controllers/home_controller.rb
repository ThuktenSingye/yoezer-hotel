class HomeController < ApplicationController
  def index
    @amenities = Amenity.all
  end
end
