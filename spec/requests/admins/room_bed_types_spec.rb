# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Admins::RoomBedTypes', type: :request do
  let!(:hotel) { FactoryBot.create(:hotel) }
  let!(:admin) { FactoryBot.create(:admin) }
  let!(:room) { FactoryBot.create(:room) }
  let!(:room_bed_type) { FactoryBot.create(:room_bed_type, room: room) }

  before do
    sign_in admin, scope: :admin
  end

  describe 'POST /create' do
    # rubocop:disable RSpec/MultipleMemoizedHelpers
    context 'with valid params' do
      subject(:create_room_bed_type) do
        post admins_hotel_room_room_bed_types_path(hotel, room), params: { room_bed_type: valid_room_bed_type_params }
        response
      end

      let(:bed_type) { FactoryBot.create(:bed_type) }
      let(:valid_room_bed_type_params) do
        {
          bed_type_id: bed_type.id,
          num_of_bed: Faker::Number.between(from: 1, to: 10)
        }
      end

      it { is_expected.to have_http_status :found }
      it { is_expected.to redirect_to admins_hotel_room_path(hotel, room) }
      it { expect { create_room_bed_type }.to change(RoomBedType, :count).by(1) }

      it 'creates a room bed type with the correct num of bed' do
        create_room_bed_type
        expect(RoomBedType.last.num_of_bed).to eq(valid_room_bed_type_params[:num_of_bed])
      end

      it 'creates a room bed type with the correct association' do
        create_room_bed_type
        expect(RoomBedType.last.bed_type_id).to eq(valid_room_bed_type_params[:bed_type_id])
      end
      # rubocop:enable RSpec/MultipleMemoizedHelpers
    end

    context 'with invalid params' do
      subject(:create_room_bed_type) do
        post admins_hotel_room_room_bed_types_path(hotel, room),
             params: { room_bed_type: invalid_room_bed_type_params }
        response
      end

      let(:invalid_room_bed_type_params) { FactoryBot.attributes_for(:room_bed_type, :invalid_room_bed_type) }

      it { is_expected.to redirect_to admins_hotel_room_path(hotel, room) }
      it { expect { create_room_bed_type }.not_to change(RoomBedType, :count) }
    end
  end

  describe 'DELETE /destroy' do
    subject(:delete_room_bed_type) do
      delete admins_hotel_room_room_bed_type_path(hotel, room, room_bed_type)
      response
    end

    it { is_expected.to redirect_to admins_hotel_room_path(hotel, room) }
    it { expect { delete_room_bed_type }.to change(RoomBedType, :count).by(-1) }
  end
end
