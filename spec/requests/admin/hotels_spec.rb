require 'rails_helper'

RSpec.describe "Admin::Hotels", type: :request do
  let(:admin) { FactoryBot.create(:admin) }
  let(:hotel) { FactoryBot.create(:hotel) }

  before do
    sign_in admin, scope: :admin
  end

  describe "GET /admin/hotels" do
    subject { get admin_hotels_path; response }
    it { is_expected.to have_http_status :ok }
  end

  describe "GET /edit" do
    subject { get edit_admin_hotel_path(hotel); response }
    it { is_expected.to have_http_status :ok }
  end

  describe "PUT /update" do
    context "with valid params" do
      let(:valid_hotel_params) do
        {
          name: "Updated Yoezer",
          email: "updated_yoezer@gmail.com",
          contact_no: "12345678",
          description: "Updated Description",
          address: {
            dzongkhag: "Updated Dzongkhag",
            gewog: "Updated Gewog",
            street_address: "Updated Street Address",
            address_type: :present
          }
        }
      end
      subject { put admin_hotel_path(hotel), params: { hotel: valid_hotel_params }; response }
      it { is_expected.to have_http_status :found }
      it { is_expected.to redirect_to admin_hotels_path }
    end

    context "with invalid params" do
        let(:invalid_hotel_params) do
          {
            name: "",
            email: "updated_yoezer@gmail.com",
            contact_no: "12345678",
            description: "Updated Description",
            address: {
              dzongkhag: "Updated Dzongkhag",
              gewog: "Updated Gewog",
              street_address: "Updated Street Address",
              address_type: :present
            }
          }
        end
        subject { put admin_hotel_path(hotel), params: { hotel: invalid_hotel_params }; response }

        it { is_expected.to have_http_status :unprocessable_content }
        it { is_expected.to render_template(:index) }
    end
  end
end
