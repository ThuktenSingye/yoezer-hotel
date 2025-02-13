# frozen_string_literal: true

# Hotel Rating Controller
class HotelsRatingController < HomeController
  def create
    if @hotel.hotel_ratings.exists?(guest_id: hotel_rating_params[:guest_id])
      flash[:alert] = I18n.t('rating.already_rated')
      return redirect_to request.referer || home_path
    end

    save_hotel_rating
    redirect_to request.referer || home_path
  end

  private

  def save_hotel_rating
    @hotel_rating = @hotel.hotel_ratings.new(hotel_rating_params)

    if @hotel_rating.save
      flash[:notice] = I18n.t('rating.create.success')
    else
      flash[:alert] = I18n.t('rating.create.error')
    end
  end

  def hotel_rating_params
    params.require(:hotel_rating).permit(:rating, :guest_id)
  end
end
