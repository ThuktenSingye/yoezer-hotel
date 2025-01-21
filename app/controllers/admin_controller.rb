# frozen_string_literal: true

# Base controller for admin interface with authentication and layout settings
class AdminController < ApplicationController
  layout 'admin'
  before_action :authenticate_admin!

  def index
    @hotel = Hotel.first
  end
end
