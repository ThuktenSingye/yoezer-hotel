# frozen_string_literal: true

# Rating Controller for guest
class RoomRatingController < HomeController
  before_action :room

  def create
    @room_rating = @room.room_ratings.new(room_rating_params)
    if @room_rating.save
      flash[:notice] = I18n.t('room_rating.create.success')
    else
      flash[:alert] = I18n.t('room_rating.create.error')
    end
    redirect_to room_path(@room)
  end

  private

  def room
    @room ||= @hotel.rooms.find(params[:room_id])
  end

  def room_rating_params
    params.require(:room_rating).permit(:rating)
  end
end
