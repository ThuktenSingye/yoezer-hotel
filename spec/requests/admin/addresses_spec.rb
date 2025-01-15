require 'rails_helper'

RSpec.describe "Admin::Addresses", type: :request do
  let(:hotel) { FactoryBot.create(:hotel) }
  let!(:address) { FactoryBot.create(:address, addressable: hotel) }
  let!(:admin) { FactoryBot.create(:admin) }

  before do
    sign_in admin, scope: :admin
  end

  describe "POST /admin/addresses" do
    context "with valid attributes" do
      let!(:valid_address_params) { FactoryBot.attributes_for(:address) }
      subject { post admin_hotel_addresses_path(hotel), params: { address: valid_address_params }; response }

      it { is_expected.to have_http_status(:found) }
      it { is_expected.to redirect_to admin_hotel_path(hotel) }
      it { expect { subject }.to change(Address, :count).by(1) }
      it { subject; expect(Address.last.attributes.slice('dzongkhag', 'gewog', 'street_address', 'address_type').merge('address_type' => Address.last.address_type.to_sym)).to eq(valid_address_params.stringify_keys) }
    end

    context "with invalid attributes" do
      let!(:invalid_address_params) { FactoryBot.attributes_for(:address, :invalid_params) }
      subject { post admin_hotel_addresses_path(hotel), params: { address: invalid_address_params }; response }

      it { is_expected.to have_http_status(:unprocessable_entity) }
      it { expect { subject }.not_to change(Address, :count) }
    end
  end


  describe "DELETE /admin/addresses/:id" do
    subject { delete admin_hotel_address_path(hotel, address); response }
    it { is_expected.to redirect_to(admin_hotels_path) }
  end
end
