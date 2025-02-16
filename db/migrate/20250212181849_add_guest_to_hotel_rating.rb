class AddGuestToHotelRating < ActiveRecord::Migration[8.0]
  def change
    add_reference :hotel_ratings, :guest, foreign_key: true
  end
end
