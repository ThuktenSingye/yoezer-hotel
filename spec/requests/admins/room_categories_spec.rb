# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Admins::RoomCategories', type: :request do
  let!(:hotel) { FactoryBot.create(:hotel) }
  let!(:admin) { FactoryBot.create(:admin) }
  let!(:room_category) { FactoryBot.create(:room_category, hotel: hotel) }

  before do
    sign_in admin, scope: :admin
    subdomain hotel.subdomain
  end

  describe 'GET /index' do
    subject do
      get admins_room_categories_path
      response
    end

    it { is_expected.to have_http_status :ok }
  end

  describe 'GET /new' do
    subject do
      get new_admins_room_category_path
      response
    end

    it { is_expected.to have_http_status :ok }
  end

  describe 'GET /edit' do
    subject do
      get edit_admins_room_category_path(room_category)
      response
    end

    it { is_expected.to have_http_status :ok }
  end

  describe 'PUT /update' do
    context 'with valid params' do
      subject(:update_room_category) do
        put admins_room_category_path(room_category), params: { room_category: valid_room_category_params }
        response
      end

      let(:valid_room_category_params) do
        {
          name: Faker::Lorem.word
        }
      end

      it { is_expected.to have_http_status :found }
      it { is_expected.to redirect_to admins_room_categories_path }
      it { expect { :update_room_category }.not_to change(RoomCategory, :count) }

      it 'update room category with correct name' do
        update_room_category
        expect(RoomCategory.last.name).to eq valid_room_category_params[:name]
      end
    end

    context 'with invalid params' do
      subject(:update_room_category) do
        put admins_room_category_path(room_category),
            params: { room_category: invalid_room_category_params }
        response
      end

      let(:invalid_room_category_params) { FactoryBot.attributes_for(:room_category, :invalid_room_category_params) }

      it { is_expected.to have_http_status :unprocessable_entity }
      it { is_expected.to render_template :edit }
      it { expect { update_room_category }.not_to change(HotelGallery, :count) }

      it 'assigns the original room category to room_category' do
        update_room_category
        expect(assigns(:room_category)).to eq(room_category)
      end
    end
  end

  describe 'POST /create' do
    context 'with valid params' do
      subject(:create_room_category) do
        post admins_room_categories_path, params: { room_category: valid_room_category_params }
        response
      end

      let(:valid_room_category_params) do
        {
          name: Faker::Lorem.word
        }
      end

      it { is_expected.to have_http_status :found }
      it { is_expected.to redirect_to admins_room_categories_path }
      it { expect { create_room_category }.to change(RoomCategory, :count).by(1) }

      it 'creates a hotel gallery with the correct name' do
        create_room_category
        expect(RoomCategory.last.name).to eq(valid_room_category_params[:name])
      end
    end

    context 'with invalid params' do
      subject(:create_room_category) do
        post admins_room_categories_path, params: { room_category: invalid_room_category_params }
        response
      end

      let(:invalid_room_category_params) { FactoryBot.attributes_for(:room_category, :invalid_room_category_params) }

      it { is_expected.to have_http_status :unprocessable_entity }
      it { is_expected.to render_template :new }
      it { expect { create_room_category }.not_to change(RoomCategory, :count) }
    end
  end

  describe 'DELETE /destroy' do
    subject(:delete_room_category) do
      delete admins_room_category_path(room_category)
      response
    end

    it { is_expected.to redirect_to admins_room_categories_path }
    it { expect { delete_room_category }.to change(RoomCategory, :count).by(-1) }
  end
end
