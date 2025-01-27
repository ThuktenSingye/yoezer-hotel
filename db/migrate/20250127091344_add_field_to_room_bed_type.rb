class AddFieldToRoomBedType < ActiveRecord::Migration[8.0]
  def change
    add_column :room_bed_types, :num_of_bed, :integer, default: 0
  end
end
