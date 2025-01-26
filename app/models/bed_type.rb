class BedType < ApplicationRecord
  validates :name, presence: true, uniqueness: true

  has_many :room_bed_types, dependent: :nullify
end
