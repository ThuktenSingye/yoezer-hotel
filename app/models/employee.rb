# frozen_string_literal: true

class Employee < ApplicationRecord
  has_one :profile, as: :profileable, dependent: :destroy
  has_many_attached :contract_files
  belongs_to :hotel
  accepts_nested_attributes_for :profile

  validates :email, presence: true, uniqueness: true
end
