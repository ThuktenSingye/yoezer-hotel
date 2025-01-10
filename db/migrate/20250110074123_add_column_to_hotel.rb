class AddColumnToHotel < ActiveRecord::Migration[8.0]
  def change
    add_column :hotels, :description, :text
  end
end
