# frozen_string_literal: true

module Admins
  # Helper module for booking
  module BookingsHelper
    def payment_status_class(status)
      case status&.to_sym
      when :completed then 'text-success'
      when :refunded then 'text-secondary'
      else 'text-error'
      end
    end

    def booking_status_class(status)
      case status&.to_sym
      when :reserved then 'text-error'
      when :booked then 'text-secondary'
      else 'text-error'
      end
    end
  end
end
