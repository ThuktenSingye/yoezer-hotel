# frozen_string_literal: true

# Represents an admins user with authentication and profile association
class Admin < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable

  devise :database_authenticatable,
         :recoverable, :rememberable, :validatable

  has_one :profile, as: :profileable, dependent: :destroy
end
