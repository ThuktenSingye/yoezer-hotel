# frozen_string_literal: true

module Admins
  module BookingsHelper
    def payment_status_class(status)
      case status.to_sym
      when :completed then 'text-success'
      when :refunded then 'text-secondary'
      else 'text-error'
      end
    end
  end
end
