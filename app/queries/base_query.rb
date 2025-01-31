# frozen_string_literal: true

# Base Query Class
class BaseQuery
  def initialize(hotel, params)
    @hotel = hotel
    @params = params
  end

  def call
    raise NotImplementedError, "You must implement the call method"
  end

  protected

  def ordered_records(records)
    records.order(created_at: :desc)
  end
end
