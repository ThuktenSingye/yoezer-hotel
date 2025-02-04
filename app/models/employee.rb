# frozen_string_literal: true

# Employee Model
class Employee < ApplicationRecord
  has_one :profile, as: :profileable, dependent: :destroy
  has_many_attached :documents
  belongs_to :hotel
  accepts_nested_attributes_for :profile

  validates :email, presence: true, uniqueness: true
end
