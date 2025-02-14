# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'HotelsRatings', type: :request do
  let(:admin) { FactoryBot.create(:admin) }
  let!(:hotel) { FactoryBot.create(:hotel) }
  let!(:guest) { FactoryBot.create(:guest, hotel: hotel) }

  before do
    subdomain hotel.subdomain
  end

  describe 'POST /create' do
    context 'with valid params' do
      subject(:create_hotel_rating) do
        post hotels_rating_index_path, params: { hotel_rating: valid_hotel_rating_params }
        response
      end

      let(:valid_hotel_rating_params) do
        {
          rating: Faker::Number.between(from: 0, to: 5),
          guest_id: guest.id
        }
      end

      it { is_expected.to have_http_status :found }
      it { expect { create_hotel_rating }.to change(HotelRating, :count).by(1) }
    end

    context 'with invalid params' do
      subject(:create_hotel_rating) do
        post hotels_rating_index_path, params: { hotel_rating: invalid_hotel_rating_params }
        response
      end

      let(:invalid_hotel_rating_params) { FactoryBot.attributes_for(:hotel_rating, :invalid_hotel_rating) }

      it { expect { create_hotel_rating }.not_to change(HotelRating, :count) }
    end
  end
end
