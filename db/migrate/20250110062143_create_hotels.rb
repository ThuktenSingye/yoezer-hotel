class CreateHotels < ActiveRecord::Migration[8.0]
  def change
    create_table :hotels do |t|
      t.string :name
      t.string :email
      t.string :contact_no

      t.timestamps
    end
  end
end
