class AddFeedbackTokenToBooking < ActiveRecord::Migration[8.0]
  def change
    add_column :bookings, :feedback_token, :string
    add_index :bookings, :feedback_token
    add_column :bookings, :feedback_expires_at, :datetime
  end
end
