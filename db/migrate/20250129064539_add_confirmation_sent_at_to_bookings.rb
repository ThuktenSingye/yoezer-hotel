class AddConfirmationSentAtToBookings < ActiveRecord::Migration[8.0]
  def change
    add_column :bookings, :confirmation_sent_at, :datetime, default: -> { 'CURRENT_TIMESTAMP' }
  end
end
