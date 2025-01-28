class Booking < ApplicationRecord
  belongs_to :guest
  belongs_to :room

  enum :payment_status, { pending: 0, completed: 1, refunded: 2 }
  validates :checkin_date, :checkout_date, :num_of_adult, :num_of_children, presence: true
end
