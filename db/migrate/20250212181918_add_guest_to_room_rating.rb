class AddGuestToRoomRating < ActiveRecord::Migration[8.0]
  def change
    add_reference :room_ratings, :guest, foreign_key: true
  end
end
