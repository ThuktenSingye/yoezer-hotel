class AddHotelReferencesToBooking < ActiveRecord::Migration[8.0]
  def change
    add_reference :bookings, :hotel, foreign_key: true
  end
end
