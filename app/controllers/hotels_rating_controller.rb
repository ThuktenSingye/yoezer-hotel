# frozen_string_literal: true

class HotelsRatingController < HomeController
  def create
    @hotel_rating = @hotel.hotel_ratings.new(hotel_rating_params)
    if @hotel_rating.save
      flash[:notice] = I18n.t('room_rating.create.success')
    else
      flash[:alert] = I18n.t('room_rating.create.error')
    end
    redirect_to contact_path
  end

  private

  def hotel_rating_params
    params.require(:hotel_rating).permit(:rating)
  end
end
