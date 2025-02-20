# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Admins::RoomFacilities', type: :request do
  let!(:hotel) { FactoryBot.create(:hotel) }
  let!(:admin) { FactoryBot.create(:admin) }
  let!(:room) { FactoryBot.create(:room) }
  let!(:room_facility) { FactoryBot.create(:room_facility, room: room) }

  before do
    sign_in admin, scope: :admin
    subdomain hotel.subdomain
  end

  describe 'POST /create' do
    # rubocop:disable RSpec/MultipleMemoizedHelpers
    context 'with valid params' do
      subject(:create_room_facility) do
        post admins_room_room_facilities_path(room), params: { room_facility: valid_room_facility_params }
        response
      end

      let(:facility) { FactoryBot.create(:facility) }
      let(:valid_room_facility_params) do
        {
          facility_id: facility.id
        }
      end

      it { is_expected.to have_http_status :found }
      it { is_expected.to redirect_to admins_room_path(room) }
      it { expect { create_room_facility }.to change(RoomFacility, :count).by(1) }

      it 'creates a room facility with the correct association' do
        create_room_facility
        expect(RoomFacility.last.facility_id).to eq(valid_room_facility_params[:facility_id])
      end
    end

    context 'with invalid params' do
      subject(:create_room_facility) do
        post admins_room_room_facilities_path(room),
             params: { room_facility: invalid_room_facility_params }
        response
      end

      let(:invalid_room_facility_params) do
        {
          facility_id: nil
        }
      end

      it { is_expected.to redirect_to admins_room_path(room) }
      it { expect { create_room_facility }.not_to change(RoomFacility, :count) }
    end
    # rubocop:enable RSpec/MultipleMemoizedHelpers
  end

  describe 'DELETE /destroy' do
    subject(:delete_room_facility) do
      delete admins_room_room_facility_path(room, room_facility)
      response
    end

    it { is_expected.to redirect_to admins_room_path(room) }
    it { expect { delete_room_facility }.to change(RoomFacility, :count).by(-1) }
  end
end
