# frozen_string_literal: true

# Helper methods for application-wide utilities
module ApplicationHelper
  include Pagy::Frontend

  def flash_class(flash_type)
    case flash_type.to_sym
    when :notice then 'flash-notice'
    when :alert  then 'flash-alert'
    else 'flash-normal'
    end
  end

  def active_class_for_sidebar(controller_name)
    'bg-white rounded' if params[:controller] == controller_name
  end

  def icon_class_for_sidebar(controller_name)
    params[:controller] == controller_name ? 'text-primary-regular' : 'text-white'
  end
end
