# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Admin::Offers', type: :request do
  let!(:hotel) { FactoryBot.create(:hotel) }
  let!(:admin) { FactoryBot.create(:admin) }
  let!(:offer) { FactoryBot.create(:offer, :with_offer_image, hotel: hotel) }

  before do
    sign_in admin, scope: :admin
  end

  describe 'GET /index' do
    subject do
      get admins_hotel_offers_path(hotel)
      response
    end

    it { is_expected.to have_http_status :ok }
  end

  describe 'GET /show' do
    context 'when offer exists' do
      subject do
        get admins_hotel_offer_path(hotel, offer)
        response
      end

      it { is_expected.to have_http_status :ok }
    end

    context 'when offer record does not exist' do
      subject do
        get admins_hotel_offer_path(hotel, offer.id + 1)
        response
      end

      it { is_expected.to redirect_to(admins_hotel_offers_path(hotel)) }
    end
  end

  describe 'GET /new' do
    subject do
      get new_admins_hotel_offer_path(hotel)
      response
    end

    it { is_expected.to have_http_status :ok }
  end

  describe 'GET /edit' do
    subject do
      get edit_admins_hotel_offer_path(hotel, offer)
      response
    end

    it { is_expected.to have_http_status :ok }
  end

  describe 'GET /update' do
    context 'with valid params' do
      subject(:update_offer) do
        put admins_hotel_offer_path(hotel, offer), params: { offer: valid_hotel_offer_params }
        response
      end

      let!(:valid_hotel_offer_params) do
        {
          title: Faker::Lorem.sentence,
          description: Faker::Lorem.paragraph,
          start_time: Faker::Time.backward(days: 30),
          end_time: Faker::Time.forward(days: 30),
          discount: Faker::Number.between(from: 0, to: 100),
          image: Rack::Test::UploadedFile.new('spec/support/images/dog.jpg', 'image/jpeg')
        }
      end

      before { update_offer }

      it { is_expected.to have_http_status :found }
      it { is_expected.to redirect_to admins_hotel_offer_path(hotel, offer) }
      it { expect(Offer.last.image).to be_attached }
      it { expect(Offer.last.image.filename.to_s).to eq(valid_hotel_offer_params[:image].original_filename) }

      it 'updates the offer with correct attributes' do
        expect(Offer.last).to have_attributes(
          title: valid_hotel_offer_params[:title], description: valid_hotel_offer_params[:description],
          start_time: valid_hotel_offer_params[:start_time], end_time: valid_hotel_offer_params[:end_time],
          discount: valid_hotel_offer_params[:discount]
        )
      end
    end

    context 'with invalid params' do
      subject(:update_offer) do
        put admins_hotel_offer_path(hotel, offer), params: { offer: invalid_hotel_offer_params }
        response
      end

      let(:invalid_hotel_offer_params) { FactoryBot.attributes_for(:offer, :invalid_offer_params) }

      it { is_expected.to have_http_status :unprocessable_entity }
      it { is_expected.to render_template :edit }

      it 'assigns the correct offer' do
        update_offer
        expect(assigns(:offer)).to eq(offer)
      end
    end
  end

  describe 'GET /create' do
    context 'with valid params' do
      subject(:create_offer) do
        post admins_hotel_offers_path(hotel), params: { offer: valid_hotel_offer_params }
        response
      end

      let(:valid_hotel_offer_params) do
        {
          title: Faker::Lorem.sentence,
          description: Faker::Lorem.paragraph,
          start_time: Faker::Time.backward(days: 30),
          end_time: Faker::Time.forward(days: 30),
          discount: Faker::Number.between(from: 0, to: 100),
          image: Rack::Test::UploadedFile.new('spec/support/images/dog.jpg', 'image/jpeg')
        }
      end

      before { create_offer }

      it { is_expected.to have_http_status :found }
      it { is_expected.to redirect_to admins_hotel_offers_path(hotel) }
      it { expect(Offer.last.image).to be_attached }
      it { expect(Offer.last.image.filename.to_s).to eq(valid_hotel_offer_params[:image].original_filename) }

      # rubocop:disable RSpec/ExampleLength
      it 'updates the offer with correct attributes' do
        expect(Offer.last).to have_attributes(
          title: valid_hotel_offer_params[:title],
          description: valid_hotel_offer_params[:description],
          start_time: valid_hotel_offer_params[:start_time],
          end_time: valid_hotel_offer_params[:end_time],
          discount: valid_hotel_offer_params[:discount]
        )
        # rubocop:enable RSpec/ExampleLength
      end
    end

    context 'with invalid params' do
      subject(:create_offer) do
        post admins_hotel_offers_path(hotel), params: { offer: invalid_hotel_offer_params }
        response
      end

      let(:invalid_hotel_offer_params) { FactoryBot.attributes_for(:offer, :invalid_offer_params) }

      it { is_expected.to have_http_status :unprocessable_entity }
      it { is_expected.to render_template :new }
      it { expect { create_offer }.not_to change(Offer, :count) }
    end
  end

  describe 'GET /destroy' do
    subject(:delete_offer) do
      delete admins_hotel_offer_path(hotel, offer)
      response
    end

    it { is_expected.to redirect_to admins_hotel_offer_path(hotel, offer) }
    it { expect { delete_offer }.to change(Offer, :count).by(-1) }
  end
end
