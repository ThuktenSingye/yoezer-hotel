class Admin::Profile < ApplicationRecord
  belongs_to :profileable, polymorphic: true

  has_many :addresses, as: :addressable

  enum :designation, [ :owner, :manager ]

  validates :first_name, presence: true
  validates :cid_no, presence: true, uniqueness: { case_sensitive: false }
  validates :contact_no, presence: true
end
