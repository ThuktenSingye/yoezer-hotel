# frozen_string_literal: true

# Rating Controller for guest
class RoomRatingController < HomeController
  before_action :room

  def create
    @room_rating = @room.room_ratings.find_or_initialize_by(guest_id: room_rating_params[:guest_id])

    if @room_rating.persisted?
      flash[:alert] = I18n.t('rating.already_rated')
    else
      save_room_rating
    end

    redirect_to request.referer || home_path
  end

  private

  def save_room_rating
    if @room_rating.update(room_rating_params)
      flash[:notice] = I18n.t('rating.create.success')
    else
      flash[:alert] = I18n.t('rating.create.error')
    end
  end

  def room
    @room ||= @hotel.rooms.find(params[:room_id])
  end

  def room_rating_params
    params.require(:room_rating).permit(:rating, :guest_id)
  end
end
