# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'RoomRatings', type: :request do
  let(:admin) { FactoryBot.create(:admin) }
  let!(:hotel) { FactoryBot.create(:hotel) }
  let!(:room) { FactoryBot.create(:room, hotel: hotel) }
  let!(:guest) { FactoryBot.create(:guest, hotel: hotel) }

  before do
    subdomain hotel.subdomain
  end

  describe 'POST /create' do
    context 'with valid params' do
      subject(:create_room_rating) do
        post room_room_rating_index_path(room), params: { room_rating: valid_room_rating_params }
        response
      end

      let(:valid_room_rating_params) do
        {
          rating: Faker::Number.between(from: 0, to: 5),
          guest_id: guest.id
        }
      end

      it { is_expected.to have_http_status :found }
      it { expect { create_room_rating }.to change(RoomRating, :count).by(1) }
    end

    context 'with invalid params' do
      subject(:create_room_rating) do
        post room_room_rating_index_path(room), params: { room_rating: invalid_room_rating_params }
        response
      end

      let(:invalid_room_rating_params) { FactoryBot.attributes_for(:room_rating, :invalid_room_rating) }

      it { expect { create_room_rating }.not_to change(RoomRating, :count) }
    end
  end
end
