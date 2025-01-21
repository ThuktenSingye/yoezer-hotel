# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Admin::Amenities', type: :request do
  let!(:admin) { FactoryBot.create(:admin) }
  let!(:hotel) { FactoryBot.create(:hotel) }
  let!(:amenity) { FactoryBot.create(:amenity, :with_amenity_image, amenityable: hotel) }

  before do
    sign_in admin, scope: :admin
  end

  describe 'GET /index' do
    subject do
      get admin_hotel_amenities_path(hotel)
      response
    end

    it { is_expected.to have_http_status :ok }
  end

  describe 'GET /new' do
    subject do
      get new_admin_hotel_amenity_path(hotel)
      response
    end

    it { is_expected.to have_http_status :ok }
  end

  describe 'POST /create' do
    context 'with valid params' do
      subject(:create_amenity) do
        post admin_hotel_amenities_path(hotel), params: { amenity: valid_amenity_params }
        response
      end

      let(:valid_amenity_params) do
        {
          name: 'Pool',
          image: Rack::Test::UploadedFile.new('spec/support/images/dog.jpg', 'image/jpeg')
        }
      end

      it { is_expected.to have_http_status :found }
      it { is_expected.to redirect_to admin_hotel_amenities_path(hotel) }
      it { expect { create_amenity }.to change(Amenity, :count).by(1) }

      it 'creates the amenity with the correct name' do
        create_amenity
        expect(Amenity.last.name).to eq(valid_amenity_params[:name])
      end

      it 'attaches the correct image' do
        create_amenity
        expect(Amenity.last.image).to be_attached
      end

      it 'sets the correct image filename' do
        create_amenity
        expect(Amenity.last.image.filename.to_s).to eq(valid_amenity_params[:image].original_filename)
      end
    end

    context 'with invalid params' do
      subject(:create_amenity) do
        post admin_hotel_amenities_path(hotel, amenity), params: { amenity: invalid_amenity_params }
        response
      end

      let(:invalid_amenity_params) { FactoryBot.attributes_for(:amenity, :invalid_amenity) }

      it { is_expected.to have_http_status :unprocessable_entity }
      it { is_expected.to render_template :new }
      it { expect { create_amenity }.not_to change(Amenity, :count) }
    end
  end

  describe 'GET /edit' do
    subject do
      get edit_admin_hotel_amenity_path(hotel, amenity)
      response
    end

    it { is_expected.to have_http_status :ok }
  end

  describe 'put /update' do
    context 'with valid params' do
      subject(:update_amenity) do
        put admin_hotel_amenity_path(hotel, amenity), params: { amenity: valid_amenity_params }
        response
      end

      let(:valid_amenity_params) do
        {
          name: 'Pool',
          image: Rack::Test::UploadedFile.new('spec/support/images/dog.jpg', 'image/jpeg')
        }
      end

      it { is_expected.to have_http_status :found }
      it { is_expected.to redirect_to admin_hotel_amenities_path(hotel) }
      it { expect { update_amenity }.not_to change(Amenity, :count) }

      it 'updates the amenity with the correct name' do
        update_amenity
        expect(Amenity.last.name).to eq(valid_amenity_params[:name])
      end

      it 'attaches the correct image' do
        update_amenity
        expect(Amenity.last.image).to be_attached
      end

      it 'sets the correct image filename' do
        update_amenity
        expect(Amenity.last.image.filename.to_s).to eq(valid_amenity_params[:image].original_filename)
      end
    end

    context 'with invalid params' do
      subject(:update_amenity) do
        put admin_hotel_amenity_path(hotel, amenity), params: { amenity: invalid_amenity_params }
        response
      end

      let(:invalid_amenity_params) { FactoryBot.attributes_for(:amenity, :invalid_amenity) }

      it { is_expected.to have_http_status :unprocessable_entity }
      it { is_expected.to render_template :edit }
      it { expect { update_amenity }.not_to change(Amenity, :count) }

      it 'assigns the correct amenity' do
        update_amenity
        expect(assigns(:amenity)).to eq(amenity)
      end
    end
  end

  describe 'DELETE /destroy' do
    subject(:delete_amenity) do
      delete admin_hotel_amenity_path(hotel, amenity)
      response
    end

    it { is_expected.to redirect_to admin_hotel_amenities_path }
    it { expect { delete_amenity }.to change(Amenity, :count).by(-1) }
  end
end
