# frozen_string_literal: true

module Admins
  # Helper methods for managing room status
  module RoomsHelper
    def status_class(status)
      case status.to_sym
      when :available then 'bg-success'
      when :booked then 'bg-secondary'
      else 'bg-error'
      end
    end
  end
end
