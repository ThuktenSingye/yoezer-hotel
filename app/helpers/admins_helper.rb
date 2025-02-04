# frozen_string_literal: true

# Helper Class for admins
module AdminsHelper
  include Pagy::Frontend

  def calculate_discounted_room_price(base_price, offers)
    discounted_price = base_price
    total_discount = 0
    offers.each do |offer|
      total_discount += offer.discount
      discounted_price -= (offer.discount * base_price) / 100.0
    end

    {
      discounted_price: discounted_price.to_i,
      total_discount: total_discount
    }
  end
end
