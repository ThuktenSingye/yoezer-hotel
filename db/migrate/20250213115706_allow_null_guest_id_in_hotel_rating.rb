class AllowNullGuestIdInHotelRating < ActiveRecord::Migration[8.0]
  def change
    change_column_null :hotel_ratings, :guest_id, true
  end
end
