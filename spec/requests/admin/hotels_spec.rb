# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Admin::Hotels', type: :request do
  let!(:admin) { FactoryBot.create(:admin) }
  let!(:hotel) { FactoryBot.create(:hotel) }

  before do
    sign_in admin, scope: :admin
  end

  describe 'GET /admin/hotels' do
    subject do
      get admin_hotels_path(hotel)
      response
    end

    it { is_expected.to have_http_status :ok }
  end

  describe 'GET /edit' do
    subject do
      get edit_admin_hotel_path(hotel)
      response
    end

    it { is_expected.to have_http_status :ok }
  end

  describe 'PUT /update' do
    context 'with valid params' do
      subject(:update_hotel) do
        put admin_hotel_path(hotel), params: { hotel: valid_hotel_params }
        response
      end

      let(:valid_hotel_params) { FactoryBot.attributes_for(:hotel) }

      it { is_expected.to have_http_status :found }
      it { is_expected.to redirect_to admin_hotels_path }
      it { expect { update_hotel }.not_to change(Hotel, :count) }

      it 'updates the hotel with the correct name' do
        update_hotel
        expect(Hotel.last.name).to eq(valid_hotel_params[:name])
      end

      it 'updates the hotel with the correct email' do
        update_hotel
        expect(Hotel.last.email).to eq(valid_hotel_params[:email])
      end

      it 'updates the hotel with the correct contact number' do
        update_hotel
        expect(Hotel.last.contact_no).to eq(valid_hotel_params[:contact_no])
      end

      it 'updates the hotel with the correct description' do
        update_hotel
        expect(Hotel.last.description).to eq(valid_hotel_params[:description])
      end
    end

    context 'with invalid params' do
      subject(:update_hotel) do
        put admin_hotel_path(hotel), params: { hotel: invalid_hotel_params }
        response
      end

      let(:invalid_hotel_params) { FactoryBot.attributes_for(:hotel, :invalid_hotel_params) }

      it { is_expected.to have_http_status(:unprocessable_entity) }
      it { is_expected.to render_template(:index) }
      it { expect { update_hotel }.not_to(change { hotel.reload.attributes.slice('name', 'email', 'contact_no') }) }
      it { expect { update_hotel }.not_to change(Hotel, :count) }

      it 'assigns the correct hotel' do
        update_hotel
        expect(assigns(:hotel)).to eq(hotel)
      end
    end
  end
end
