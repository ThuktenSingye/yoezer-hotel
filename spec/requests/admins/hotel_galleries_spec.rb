# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Admin::HotelGalleries', type: :request do
  let!(:hotel) { FactoryBot.create(:hotel) }
  let!(:admin) { FactoryBot.create(:admin) }
  let!(:gallery) { FactoryBot.create(:hotel_gallery, :with_hotel_image, hotel: hotel) }

  before do
    sign_in admin, scope: :admin
  end

  describe 'GET /index' do
    subject do
      get admins_hotel_hotel_galleries_path(hotel)
      response
    end

    it { is_expected.to have_http_status :ok }
  end

  describe 'GET /new' do
    subject do
      get new_admins_hotel_hotel_gallery_path(hotel)
      response
    end

    it { is_expected.to have_http_status :ok }
  end

  describe 'GET /show' do
    context 'when gallery exists' do
      subject do
        get admins_hotel_hotel_gallery_path(hotel, gallery)
        response
      end

      it { is_expected.to have_http_status :ok }
    end

    context 'when gallery record does not exist' do
      subject do
        get admins_hotel_hotel_gallery_path(hotel, gallery.id + 1)
        response
      end

      it { is_expected.to redirect_to(admins_hotel_hotel_galleries_path(hotel)) }
    end
  end

  describe 'GET /edit' do
    subject do
      get edit_admins_hotel_hotel_gallery_path(hotel, gallery)
      response
    end

    it { is_expected.to have_http_status :ok }
  end

  describe 'UPDATE /update' do
    context 'with valid params' do
      subject(:update_gallery) do
        put admins_hotel_hotel_gallery_path(hotel, gallery), params: { hotel_gallery: valid_hotel_gallery_params }
        response
      end

      let(:valid_hotel_gallery_params) do
        {
          name: Faker::Company.name,
          description: Faker::Lorem.sentence,
          image: Rack::Test::UploadedFile.new('spec/support/images/dog.jpg', 'image/jpeg')
        }
      end

      before { update_gallery }

      it { is_expected.to have_http_status :found }
      it { is_expected.to redirect_to admins_hotel_hotel_galleries_path(hotel) }
      it { expect(HotelGallery.last.image).to be_attached }

      it 'update the hotel gallery with correct attributes' do
        expect(HotelGallery.last).to have_attributes(
          name: valid_hotel_gallery_params[:name],
          description: valid_hotel_gallery_params[:description]
        )
      end
    end

    context 'with invalid params' do
      subject(:update_gallery) do
        put admins_hotel_hotel_gallery_path(hotel, gallery), params: { hotel_gallery: invalid_hotel_gallery_params }
        response
      end

      let(:invalid_hotel_gallery_params) { FactoryBot.attributes_for(:hotel_gallery, :invalid_hotel_gallery) }

      it { is_expected.to have_http_status :unprocessable_entity }
      it { is_expected.to render_template :edit }
      it { expect { update_gallery }.not_to change(HotelGallery, :count) }

      it 'assigns the correct hotel gallery' do
        update_gallery
        expect(assigns(:hotel_gallery)).to eq(gallery)
      end
    end
  end

  describe 'POST /create' do
    context 'with valid params' do
      subject(:create_gallery) do
        post admins_hotel_hotel_galleries_path(hotel), params: { hotel_gallery: valid_hotel_gallery_params }
        response
      end

      let(:valid_hotel_gallery_params) do
        {
          name: Faker::Company.name,
          description: Faker::Lorem.sentence,
          image: Rack::Test::UploadedFile.new('spec/support/images/dog.jpg', 'image/jpeg')
        }
      end

      before { create_gallery }

      it { is_expected.to have_http_status :found }
      it { is_expected.to redirect_to admins_hotel_hotel_galleries_path(hotel) }
      it { expect(HotelGallery.last.image).to be_attached }

      it 'update the hotel gallery with correct attributes' do
        expect(HotelGallery.last).to have_attributes(
          name: valid_hotel_gallery_params[:name],
          description: valid_hotel_gallery_params[:description]
        )
      end
    end

    context 'with invalid params' do
      subject(:create_gallery) do
        post admins_hotel_hotel_galleries_path(hotel), params: { hotel_gallery: invalid_hotel_gallery_params }
        response
      end

      let(:invalid_hotel_gallery_params) { FactoryBot.attributes_for(:hotel_gallery, :invalid_hotel_gallery) }

      it { is_expected.to have_http_status :unprocessable_entity }
      it { is_expected.to render_template :new }
      it { expect { create_gallery }.not_to change(HotelGallery, :count) }
    end
  end

  describe 'DELETE /destroy' do
    subject(:delete_gallery) do
      delete admins_hotel_hotel_gallery_path(hotel, gallery)
      response
    end

    it { is_expected.to redirect_to admins_hotel_hotel_galleries_path(hotel) }
    it { expect { delete_gallery }.to change(HotelGallery, :count).by(-1) }
  end
end
