class AddConfirmationExpiresAtToBooking < ActiveRecord::Migration[8.0]
  def change
    add_column :bookings, :confirmation_expires_at, :datetime
  end
end
