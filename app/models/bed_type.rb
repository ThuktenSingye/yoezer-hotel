# frozen_string_literal: true

# Room BedType model
class BedType < ApplicationRecord
  validates :name, presence: true, uniqueness: true

  belongs_to :hotel
  has_many :room_bed_types, dependent: :nullify
end
