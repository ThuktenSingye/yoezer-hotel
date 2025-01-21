# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Admin::Addresses', type: :request do
  let(:hotel) { FactoryBot.create(:hotel) }
  let!(:address) { FactoryBot.create(:address, addressable: hotel) }
  let!(:admin) { FactoryBot.create(:admin) }

  before do
    sign_in admin, scope: :admin
  end

  describe 'POST /admin/addresses' do
    context 'with valid attributes' do
      subject(:create_address) do
        post admin_hotel_addresses_path(hotel), params: { address: valid_address_params }
        response
      end

      let!(:valid_address_params) { FactoryBot.attributes_for(:address) }

      it { is_expected.to have_http_status(:found) }
      it { is_expected.to redirect_to admin_hotel_path(hotel) }
      it { expect { create_address }.to change(Address, :count).by(1) }

      it 'creates an address with the correct dzongkhag' do
        create_address
        expect(Address.last.dzongkhag).to eq(valid_address_params[:dzongkhag])
      end

      it 'creates an address with the correct gewog' do
        create_address
        expect(Address.last.gewog).to eq(valid_address_params[:gewog])
      end

      it 'creates an address with the correct address_type' do
        create_address
        expect(Address.last.address_type).to eq(valid_address_params[:address_type])
      end
    end

    context 'with invalid attributes' do
      subject(:create_address) do
        post admin_hotel_addresses_path(hotel), params: { address: invalid_address_params }
        response
      end

      let!(:invalid_address_params) { FactoryBot.attributes_for(:address, :invalid_params) }

      it { is_expected.to have_http_status(:unprocessable_entity) }
      it { expect { create_address }.not_to change(Address, :count) }
    end
  end

  describe 'DELETE /admin/addresses/:id' do
    subject do
      delete admin_hotel_address_path(hotel, address)
      response
    end

    it { is_expected.to redirect_to(admin_hotels_path) }
  end
end
