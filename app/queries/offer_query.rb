# frozen_string_literal: true

# Query class for offer model
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
    offers.where('start_time <= ? AND end_time >= ?', Time.zone.today, Time.zone.today)
  end

  def ordered_records(records)
    records.order(created_at: :desc)
  end
end
