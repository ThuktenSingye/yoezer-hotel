require 'rails_helper'

RSpec.describe "Admin::Hotels", type: :request do
  let!(:admin) { FactoryBot.create(:admin) }
  let!(:hotel) { FactoryBot.create(:hotel) }

  before do
    sign_in admin, scope: :admin
  end

  describe "GET /admin/hotels" do
    subject { get admin_hotels_path(hotel); response }
    it { is_expected.to have_http_status :ok }
  end

  describe "GET /edit" do
    subject { get edit_admin_hotel_path(hotel); response }
    it { is_expected.to have_http_status :ok }
  end

  describe "PUT /update" do
    context "with valid params" do
      let(:valid_hotel_params) { FactoryBot.attributes_for(:hotel) }
      subject { put admin_hotel_path(hotel), params: { hotel: valid_hotel_params }; response }

      it { is_expected.to have_http_status :found }
      it { is_expected.to redirect_to admin_hotels_path }
      it { expect { subject }.not_to change(Hotel, :count) }
      it { subject; hotel.reload; expect(hotel.attributes.slice('name', 'email', 'contact_no', 'description')).to eq(valid_hotel_params.stringify_keys) }
    end

    context "with invalid params" do
      let(:invalid_hotel_params) { FactoryBot.attributes_for(:hotel, :invalid_hotel_params) }
      subject { put admin_hotel_path(hotel), params: { hotel: invalid_hotel_params }; response }

      it { is_expected.to have_http_status(:unprocessable_entity) }
      it { is_expected.to render_template(:index) }
      it { expect { subject }.not_to change { hotel.reload.attributes.slice('name', 'email', 'contact_no') } }
      it { expect { subject }.not_to change(Hotel, :count) }
      it { subject; expect(assigns(:hotel)).to eq(hotel) }
    end
  end
end
