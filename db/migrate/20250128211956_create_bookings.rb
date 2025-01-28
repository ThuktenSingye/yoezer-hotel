class CreateBookings < ActiveRecord::Migration[8.0]
  def change
    create_table :bookings do |t|
      t.datetime :checkin_date
      t.datetime :checkout_date
      t.integer :num_of_adult
      t.integer :num_of_children
      t.integer :payment_status
      t.decimal :total_amount
      t.string :confirmation_token
      t.boolean :confirmed
      t.references :guest, null: false, foreign_key: true
      t.references :room, null: false, foreign_key: true

      t.timestamps
    end
  end
end
