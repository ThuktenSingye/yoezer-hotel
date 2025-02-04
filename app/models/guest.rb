# frozen_string_literal: true

# Guest Model
class Guest < ApplicationRecord
  belongs_to :hotel

  validates :first_name, :contact_no, :email, :country, :region, :city, presence: true
end
