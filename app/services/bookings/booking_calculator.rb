# frozen_string_literal: true

module Bookings
  # Booking class for price calculation
  class BookingCalculator
    def self.calculate_total_amount(checkin_date, checkout_date, room, offers)
      checkin_date = parse_date(checkin_date)
      checkout_date = parse_date(checkout_date)

      total_price = calculate_total_price(checkin_date, checkout_date, room.base_price, offers)
      total_price.positive? ? total_price : room.base_price
    end

    def self.calculate_total_price(checkin_date, checkout_date, base_price, offers)
      total_discount = 0
      (checkin_date...checkout_date).each do |date|
        applicable_offer = find_applicable_offer(date, offers)
        total_discount += calculate_discount(base_price, applicable_offer.discount) if applicable_offer
      end
      total_price = (checkout_date - checkin_date).to_i * base_price
      total_price - total_discount
    end

    def self.parse_date(date_string)
      return date_string if date_string.is_a?(Date)

      Date.parse(date_string) if date_string.present?
    end

    def self.find_applicable_offer(date, offers)
      offers.find do |offer|
        offer_start_date = parse_date(offer.start_time)
        offer_end_date = parse_date(offer.end_time)

        date >= offer_start_date && date <= offer_end_date
      end
    end

    def self.calculate_discount(base_price, discount_percentage)
      (discount_percentage * base_price) / 100.0
    end
  end
end
