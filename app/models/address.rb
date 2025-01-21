# frozen_string_literal: true

# Polymorphic model for storing addresses
class Address < ApplicationRecord
  belongs_to :addressable, polymorphic: true

  enum :address_type, { present: 0, permanent: 1 }

  validates :dzongkhag, presence: true
  validates :gewog, presence: true
  validates :street_address, presence: true
end
