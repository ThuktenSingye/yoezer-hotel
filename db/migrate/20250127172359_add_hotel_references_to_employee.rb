class AddHotelReferencesToEmployee < ActiveRecord::Migration[8.0]
  def change
    add_reference :employees, :hotel, foreign_key: true
  end
end
