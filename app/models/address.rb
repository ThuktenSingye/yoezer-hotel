class Address < ApplicationRecord
  belongs_to :addressable, polymorphic: true

  enum :address_type, [ :present, :permanent ]

  validates :dzongkhag, presence: true
  validates :gewog, presence: true
  validates :street_address, presence: true
end
