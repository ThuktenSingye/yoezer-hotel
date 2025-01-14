require 'rails_helper'

RSpec.describe "Admin::Addresses", type: :request do
  let(:hotel) { FactoryBot.create(:hotel) }
  let(:address) { FactoryBot.create(:address, addressable: hotel) }
  let(:admin) { FactoryBot.create(:admin) }

  before do
    sign_in admin, scope: :admin
  end

  describe "POST /admin/addresses" do
    context "with valid attributes" do
      subject { post admin_hotel_addresses_path(hotel), params: { address: FactoryBot.attributes_for(:address) }; response }

      it { is_expected.to have_http_status(:found) }
    end

    context "with invalid attributes" do
      subject { post admin_hotel_addresses_path(hotel), params: { address: FactoryBot.attributes_for(:address, :invalid_params) }; response }

      it { is_expected.to have_http_status(:unprocessable_entity) }
    end
  end


  describe "DELETE /admin/addresses/:id" do
    subject { delete admin_hotel_address_path(hotel, address); response }
    it { is_expected.to redirect_to(admin_hotels_path) }
  end
end
