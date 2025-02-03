# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Admins::Addresses', type: :request do
  let(:hotel) { FactoryBot.create(:hotel) }
  let!(:address) { FactoryBot.create(:address, addressable: hotel) }
  let!(:admin) { FactoryBot.create(:admin) }

  before do
    sign_in admin, scope: :admin
  end

  describe 'POST /admins/addresses' do
    let!(:valid_address_params) { FactoryBot.attributes_for(:address) }
    let!(:invalid_address_params) { FactoryBot.attributes_for(:address, :invalid_params) }

    context 'with valid attributes' do
      subject(:create_address) do
        post admins_hotel_addresses_path(hotel), params: { address: valid_address_params }
        response
      end

      it { is_expected.to have_http_status(:found) }
      it { is_expected.to redirect_to admins_hotel_path(hotel) }
      it { expect { create_address }.to change(Address, :count).by(1) }

      it 'create an address with correct attributes' do
        create_address
        expect(Address.last).to have_attributes(
          dzongkhag: valid_address_params[:dzongkhag], gewog: valid_address_params[:gewog],
          address_type: valid_address_params[:address_type].to_s
        )
      end
    end

    context 'with invalid attributes' do
      subject(:create_address) do
        post admins_hotel_addresses_path(hotel), params: { address: invalid_address_params }
        response
      end

      it { is_expected.to have_http_status(:unprocessable_entity) }
      it { expect { create_address }.not_to change(Address, :count) }
    end
  end

  describe 'DELETE /admins/addresses/:id' do
    subject do
      delete admins_hotel_address_path(hotel, address)
      response
    end

    it { is_expected.to redirect_to(admins_hotels_path) }
  end
end
