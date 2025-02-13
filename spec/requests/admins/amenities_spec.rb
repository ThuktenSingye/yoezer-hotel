# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'AdminPanel::Amenities', type: :request do
  let!(:admin) { FactoryBot.create(:admin) }
  let!(:hotel) { FactoryBot.create(:hotel) }
  let!(:amenity) { FactoryBot.create(:amenity, :with_amenity_image, amenityable: hotel) }

  before do
    sign_in admin, scope: :admin
    set_subdomain hotel.subdomain
  end

  describe 'GET /index' do
    subject do
      get admins_amenities_path
      response
    end

    it { is_expected.to have_http_status :ok }
  end

  describe 'GET /new' do
    subject do
      get new_admins_amenity_path
      response
    end

    it { is_expected.to have_http_status :ok }
  end

  describe 'POST /create' do
    context 'with valid params' do
      subject(:create_amenity) do
        post admins_amenities_path, params: { amenity: valid_amenity_params }
        response
      end

      let(:valid_amenity_params) do
        {
          name: 'Pool',
          image: Rack::Test::UploadedFile.new('spec/support/images/dog.jpg', 'image/jpeg')
        }
      end

      before { create_amenity }

      it { is_expected.to have_http_status(:found) }
      it { is_expected.to redirect_to(admins_amenities_path) }
      it { expect(Amenity.last).to have_attributes(name: valid_amenity_params[:name]) }
      it { expect(Amenity.last.image).to be_attached }
      it { expect(Amenity.last.image.filename.to_s).to eq(valid_amenity_params[:image].original_filename) }
    end

    context 'with invalid params' do
      subject(:create_amenity) do
        post admins_amenities_path(amenity), params: { amenity: invalid_amenity_params }
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
      get edit_admins_amenity_path(amenity)
      response
    end

    it { is_expected.to have_http_status :ok }
  end

  describe 'put /update' do
    context 'with valid params' do
      subject(:update_amenity) do
        put admins_amenity_path(amenity), params: { amenity: valid_amenity_params }
        response
      end

      let(:valid_amenity_params) do
        {
          name: 'Pool',
          image: Rack::Test::UploadedFile.new('spec/support/images/dog.jpg', 'image/jpeg')
        }
      end

      before { update_amenity }

      it { is_expected.to have_http_status :found }
      it { is_expected.to redirect_to admins_amenities_path }
      it { expect(Amenity.last).to have_attributes(name: valid_amenity_params[:name]) }
      it { expect(Amenity.last.image).to be_attached }
      it { expect(Amenity.last.image.filename.to_s).to eq(valid_amenity_params[:image].original_filename) }
    end

    context 'with invalid params' do
      subject(:update_amenity) do
        put admins_amenity_path(amenity), params: { amenity: invalid_amenity_params }
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
      delete admins_amenity_path(amenity)
      response
    end

    it { is_expected.to redirect_to admins_amenities_path }
    it { expect { delete_amenity }.to change(Amenity, :count).by(-1) }
  end
end
