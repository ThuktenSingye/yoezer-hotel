class CreateGuests < ActiveRecord::Migration[8.0]
  def change
    create_table :guests do |t|
      t.string :first_name
      t.string :last_name
      t.string :contact_no
      t.string :email
      t.string :country
      t.string :region
      t.string :city
      t.references :hotel, null: false, foreign_key: true

      t.timestamps
    end
  end
end
