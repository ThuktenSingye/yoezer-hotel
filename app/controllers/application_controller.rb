# frozen_string_literal: true

# Base controller for the application with browser support settings
class ApplicationController < ActionController::Base
  include Pagy::Backend
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern
  before_action :hotel

  private

  def hotel
    @hotel ||= find_hotel
  end

  def find_hotel
    if request.subdomain.present?
      Hotel.find_by(subdomain: request.subdomain) || default_hotel
    else
      default_hotel
    end
  end

  def default_hotel
    default_hotel_id = 3
    Hotel.find(default_hotel_id)
  end
end
