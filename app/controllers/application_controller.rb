# frozen_string_literal: true

# Base controller for the application with browser support settings
class ApplicationController < ActionController::Base
  include Pagy::Backend
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern
  before_action :set_global_hotel

  private

  def set_global_hotel
    @hotel = Hotel.find_by(subdomain: request.subdomain)
    # @hotel = Hotel.includes(:address).first
  end
end
