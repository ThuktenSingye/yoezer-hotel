# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Admins::BedTypes', type: :request do
  let!(:hotel) { FactoryBot.create(:hotel) }
  let!(:admin) { FactoryBot.create(:admin) }
  let!(:bed_type) { FactoryBot.create(:bed_type) }

  before do
    sign_in admin, scope: :admin
  end

  describe 'GET /index' do
    subject do
      get admins_hotel_bed_types_path(hotel)
      response
    end

    it { is_expected.to have_http_status :ok }
  end

  describe 'GET /new' do
    subject do
      get new_admins_hotel_bed_type_path(hotel)
      response
    end

    it { is_expected.to have_http_status :ok }
  end

  describe 'GET /edit' do
    subject do
      get edit_admins_hotel_bed_type_path(hotel, bed_type)
      response
    end

    it { is_expected.to have_http_status :ok }
  end

  describe 'PUT /update' do
    context 'with valid params' do
      subject(:update_bed_type) do
        put admins_hotel_bed_type_path(hotel, bed_type), params: { bed_type: valid_bed_type_params }
        response
      end

      let(:valid_bed_type_params) do
        {
          name: Faker::Lorem.word
        }
      end

      it { is_expected.to have_http_status :found }
      it { is_expected.to redirect_to admins_hotel_room_categories_path(hotel) }
      it { expect { :update_bed_type }.not_to change(BedType, :count) }

      it 'update room bed type with correct name' do
        update_bed_type
        expect(BedType.last.name).to eq valid_bed_type_params[:name]
      end
    end

    context 'with invalid params' do
      subject(:update_bed_type) do
        put admins_hotel_bed_type_path(hotel, bed_type), params: { bed_type: invalid_bed_type_params }
        response
      end

      let(:invalid_bed_type_params) { FactoryBot.attributes_for(:bed_type, :invalid_bed_type) }

      it { is_expected.to have_http_status :unprocessable_entity }
      it { is_expected.to render_template :edit }
      it { expect { update_bed_type }.not_to change(BedType, :count) }

      it 'assigns the original room bed type to bed type' do
        update_bed_type
        expect(assigns(:bed_type)).to eq(bed_type)
      end
    end
  end

  describe 'POST /create' do
    context 'with valid params' do
      subject(:create_bed_type) do
        post admins_hotel_bed_types_path(hotel), params: { bed_type: valid_bed_type_params }
        response
      end

      let(:valid_bed_type_params) do
        {
          name: Faker::Lorem.word
        }
      end

      it { is_expected.to have_http_status :found }
      it { is_expected.to redirect_to admins_hotel_room_categories_path(hotel) }
      it { expect { create_bed_type }.to change(BedType, :count).by(1) }

      it 'creates a hotel gallery with the correct name' do
        create_bed_type
        expect(BedType.last.name).to eq(valid_bed_type_params[:name])
      end
    end

    context 'with invalid params' do
      subject(:create_bed_type) do
        post admins_hotel_bed_types_path(hotel), params: { bed_type: invalid_bed_type_params }
        response
      end

      let(:invalid_bed_type_params) { FactoryBot.attributes_for(:bed_type, :invalid_bed_type) }

      it { is_expected.to have_http_status :unprocessable_entity }
      it { is_expected.to render_template :new }
      it { expect { create_bed_type }.not_to change(BedType, :count) }
    end
  end

  describe 'DELETE /destroy' do
    subject(:delete_bed_type) do
      delete admins_hotel_bed_type_path(hotel, bed_type)
      response
    end

    it { is_expected.to redirect_to admins_hotel_room_categories_path(hotel) }
    it { expect { delete_bed_type }.to change(BedType, :count).by(-1) }
  end
end
