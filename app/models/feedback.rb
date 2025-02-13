# frozen_string_literal: true

# Feedback model associated with a hotel
class Feedback < ApplicationRecord
  belongs_to :hotel

  validates :name, :email, :feedback, presence: true
end
