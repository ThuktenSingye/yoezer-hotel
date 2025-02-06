class ExploreController < ApplicationController

  def index
    @hotels_feature = HotelGallery.all
  end
end
