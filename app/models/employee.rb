# frozen_string_literal: true

# Employee Model
class Employee < ApplicationRecord
  has_one :profile, as: :profileable, dependent: :destroy
  has_many_attached :contract_files
  belongs_to :hotel
  accepts_nested_attributes_for :profile, allow_destroy: true

  validates :email, presence: true, uniqueness: true
end
