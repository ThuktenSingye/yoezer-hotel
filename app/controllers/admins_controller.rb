# frozen_string_literal: true

# Base controller for admins interface with authentication and layout settings
class AdminsController < ApplicationController
  layout 'admins'
  before_action :authenticate_admin!

  def index
    @hotel = Hotel.first
  end
end
