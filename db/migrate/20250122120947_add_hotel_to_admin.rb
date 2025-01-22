class AddHotelToAdmin < ActiveRecord::Migration[8.0]
  def change
    add_reference :admins, :hotel, null: false, foreign_key: true
  end
end
