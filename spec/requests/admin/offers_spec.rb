require 'rails_helper'

RSpec.describe "Admin::Offers", type: :request do
  let!(:hotel) { FactoryBot.create(:hotel) }
  let!(:admin) { FactoryBot.create(:admin) }
  let!(:offer) { FactoryBot.create(:offer, :with_offer_image, hotel: hotel) }

  before do
    sign_in admin, scope: :admin
  end

  describe "GET /index" do
    subject { get admin_hotel_offers_path(hotel); response }
    it { is_expected.to have_http_status :ok }
  end

  describe "GET /show" do
    context "when offer exists" do
      subject { get admin_hotel_offer_path(hotel, offer); response }
      it { is_expected.to have_http_status :ok }
    end

    context "when offer record does not exist" do
      subject { get admin_hotel_offer_path(hotel, offer.id + 1); response }
      it { is_expected.to redirect_to(admin_hotel_offers_path(hotel)) }
    end
  end

  describe "GET /new" do
    subject { get new_admin_hotel_offer_path(hotel); response }
    it { is_expected.to have_http_status :ok }
  end

  describe "GET /edit" do
    subject { get edit_admin_hotel_offer_path(hotel, offer); response }
    it { is_expected.to have_http_status :ok }
  end

  describe "GET /update" do
    let!(:offer_attributes) { %w[title description start_time end_time discount] }
    context "with valid params" do
      let!(:valid_hotel_offer_params) do
        {
          title: Faker::Lorem.sentence,
          description: Faker::Lorem.paragraph,
          start_time: Faker::Time.backward(days: 30),
          end_time: Faker::Time.forward(days: 30),
          discount: Faker::Number.between(from: 0, to: 100),
          image: Rack::Test::UploadedFile.new("spec/support/images/dog.jpg", "image/jpeg")
        }
      end
      subject { put admin_hotel_offer_path(hotel, offer), params: { offer: valid_hotel_offer_params }; response }

      it { is_expected.to have_http_status :found }
      it { is_expected.to redirect_to admin_hotel_offer_path(hotel, offer) }
      it { expect { subject }.not_to change(Offer, :count) }
      it "update offer with valid attributes" do
        subject
        offer.reload
        expect(offer.attributes.slice(*offer_attributes)).to eq(valid_hotel_offer_params.stringify_keys.except('image'))
        expect(offer.image.filename.to_s).to eq(valid_hotel_offer_params[:image].original_filename)
        expect(offer.image).to be_attached
      end
    end

    context "invalid params" do
      let(:invalid_hotel_offer_params) { FactoryBot.attributes_for(:offer, :invalid_offer_params) }
      subject { put admin_hotel_offer_path(hotel, offer), params: { offer: invalid_hotel_offer_params }; response }

      it { is_expected.to have_http_status :unprocessable_entity }
      it { is_expected.to render_template :edit }
      it { subject; expect(assigns(:offer)).to eq(offer) }
      it { expect { subject }.not_to change(Offer, :count) }
    end
  end

  describe "GET /create" do
    let!(:offer_attributes) { %w[title description start_time end_time discount] }
    context "with valid params" do
      let(:valid_hotel_offer_params) do
        {
          title: Faker::Lorem.sentence,
          description: Faker::Lorem.paragraph,
          start_time: Faker::Time.backward(days: 30),
          end_time: Faker::Time.forward(days: 30),
          discount: Faker::Number.between(from: 0, to: 100),
          image: Rack::Test::UploadedFile.new("spec/support/images/dog.jpg", "image/jpeg")
        }
      end
      subject { post admin_hotel_offers_path(hotel), params: { offer: valid_hotel_offer_params }; response }

      it { is_expected.to have_http_status :found }
      it { is_expected.to redirect_to admin_hotel_offers_path(hotel) }
      it { expect { subject }.to change(Offer, :count).by(1) }
      it "update profile with valid attributes" do
        subject
        offer = Offer.last
        expect(offer.attributes.slice(*offer_attributes)).to eq(valid_hotel_offer_params.stringify_keys.except('image'))
        expect(offer.image.filename.to_s).to eq(valid_hotel_offer_params[:image].original_filename)
        expect(offer.image).to be_attached
      end
    end

    context "with invalid params" do
      let(:invalid_hotel_offer_params) { FactoryBot.attributes_for(:offer, :invalid_offer_params) }
      subject { post admin_hotel_offers_path(hotel), params: { offer: invalid_hotel_offer_params }; response }

      it { is_expected.to have_http_status :unprocessable_entity }
      it { is_expected.to render_template :new }
      it { expect { subject }.not_to change(Offer, :count) }
    end
  end


  describe "GET /destroy" do
    subject { delete admin_hotel_offer_path(hotel, offer); response }
    it { is_expected.to redirect_to admin_hotel_offer_path(hotel, offer) }
    it { expect { subject }.to change(Offer, :count).by(-1) }
  end
end
