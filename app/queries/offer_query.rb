# frozen_string_literal: true

class OfferQuery
  def initialize(hotel)
    @hotel = hotel
  end

  def call
    offers = @hotel.offers
    offers = search_offer(offers)
    ordered_records(offers)
  end

  private

  def search_offer(offers)
    offers.where('start_time <= ? AND end_time >= ?', Date.today, Date.today)
  end

  def ordered_records(records)
    records.order(created_at: :desc)
  end
end
