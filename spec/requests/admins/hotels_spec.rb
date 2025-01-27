# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Admins::Hotels', type: :request do
  let!(:admin) { FactoryBot.create(:admin) }
  let!(:hotel) { FactoryBot.create(:hotel) }

  before do
    sign_in admin, scope: :admin
  end

  describe 'GET /admins/hotels' do
    subject do
      get admins_hotels_path(hotel)
      response
    end

    it { is_expected.to have_http_status :ok }
  end

  describe 'GET /edit' do
    subject do
      get edit_admins_hotel_path(hotel)
      response
    end

    it { is_expected.to have_http_status :ok }
  end

  describe 'PUT /update' do
    context 'with valid params' do
      subject(:update_hotel) do
        put admins_hotel_path(hotel), params: { hotel: valid_hotel_params }
        response
      end

      let(:valid_hotel_params) { FactoryBot.attributes_for(:hotel) }

      it { is_expected.to have_http_status :found }
      it { is_expected.to redirect_to admins_hotels_path }
      it { expect { update_hotel }.not_to change(Hotel, :count) }

      it 'updates the hotel with the correct attributes' do
        update_hotel
        expect(Hotel.last).to have_attributes(
          name: valid_hotel_params[:name],
          email: valid_hotel_params[:email],
          contact_no: valid_hotel_params[:contact_no],
          description: valid_hotel_params[:description]
        )
      end
    end

    context 'with invalid params' do
      subject(:update_hotel) do
        put admins_hotel_path(hotel), params: { hotel: invalid_hotel_params }
        response
      end

      let(:invalid_hotel_params) { FactoryBot.attributes_for(:hotel, :invalid_hotel_params) }

      it { is_expected.to have_http_status(:unprocessable_entity) }
      it { is_expected.to render_template(:index) }
      it { expect { update_hotel }.not_to change(Hotel, :count) }

      it 'assigns the correct hotel' do
        update_hotel
        expect(assigns(:hotel)).to eq(hotel)
      end
    end
  end
end
