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

    # def calculate_rating(record_rating)
    #   {
    #     full_stars: record_rating.to_i,
    #     half_stars: record_rating - record_rating.to_i >= 0.5,
    #     empty_stars: 5 - record_rating.to_i - (record_rating - record_rating.to_i ? 1 : 0)
    #   }
    # end
  end
end
