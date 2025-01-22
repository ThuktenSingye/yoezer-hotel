# frozen_string_literal: true

# Polymorphic profile model
class Profile < ApplicationRecord
  belongs_to :profileable, polymorphic: true
  has_many :addresses, as: :addressable, dependent: :destroy
  accepts_nested_attributes_for :addresses
  has_one_attached :avatar

  enum :designation, { owner: 0, manager: 1, employee: 2 }

  validates :first_name, :contact_no, :cid_no, presence: true
  validates :cid_no, uniqueness: true
end
