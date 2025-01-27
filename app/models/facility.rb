# frozen_string_literal: true

# Room Facility Model
class Facility < ApplicationRecord
  belongs_to :hotel
  has_one_attached :image

  validates :name, presence: true, uniqueness: { case_sensitive: false }
end
