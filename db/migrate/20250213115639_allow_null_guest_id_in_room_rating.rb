class AllowNullGuestIdInRoomRating < ActiveRecord::Migration[8.0]
  def change
    change_column_null :room_ratings, :guest_id, true
  end
end
