class Profile < ApplicationRecord
  belongs_to :profileable, polymorphic: true
  has_many :addresses, as: :addressable
  accepts_nested_attributes_for :addresses
  has_one_attached :avatar

  enum :designation, [ :owner, :manager, :employee ]

  validates :first_name, presence: true
  validates :cid_no, presence: true, uniqueness: { case_sensitive: false }
  validates :contact_no, presence: true
end
