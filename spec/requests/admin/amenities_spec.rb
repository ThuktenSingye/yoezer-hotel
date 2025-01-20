require 'rails_helper'

RSpec.describe "Admin::Amenities", type: :request do
  let!(:admin) { FactoryBot.create(:admin) }
  let!(:hotel) { FactoryBot.create(:hotel) }
  let!(:amenity) { FactoryBot.create(:amenity, :with_amenity_image, amenityable: hotel) }

  before do
    sign_in admin, scope: :admin
  end

  describe "GET /index" do
    subject { get admin_hotel_amenities_path(hotel); response }
    it { is_expected.to have_http_status :ok }
  end

  describe "GET /new" do
    subject { get new_admin_hotel_amenity_path(hotel); response }
    it { is_expected.to have_http_status :ok }
  end

  describe "POST /create" do
    # context "with valid params" do
    #   let(:valid_amenity_params) do
    #     {
    #       name: "Pool",
    #       image: Rack::Test::UploadedFile.new("spec/support/images/dog.jpg", "image/jpeg")
    #     }
    #   end
    #
    #   subject { post admin_hotel_amenities_path(hotel), params: { amenity: valid_amenity_params }; response }
    #
    #   it { is_expected.to have_http_status :found }
    #   it { is_expected.to redirect_to admin_hotel_amenities_path(hotel) }
    #   it { expect { subject }.to change(Amenity, :count).by(1) }
    #   it "creates the amenity with the correct attributes" do
    #     subject
    #     amenity = Amenity.last
    #     expect(amenity.name).to eq(valid_amenity_params[:name])
    #     expect(amenity.image).to be_attached
    #     expect(amenity.image.filename.to_s).to eq(valid_amenity_params[:image].original_filename)
    #   end
    # end

    context "with invalid params" do
      let(:invalid_amenity_params) { FactoryBot.attributes_for(:amenity, :invalid_amenity) }
      subject { post admin_hotel_amenities_path(hotel, amenity), params: { amenity: invalid_amenity_params } ; response }
      # it "dcs" do
      #   binding.pry
      # end
      it { is_expected.to have_http_status :unprocessable_entity }
      # it { is_expected.to render_template :new }
      it { expect { subject }.not_to change(Amenity, :count) }
    end
  end

  describe "GET /edit" do
    subject { get edit_admin_hotel_amenity_path(hotel, amenity); response }
    it { is_expected.to have_http_status :ok }
  end

  describe "put /update" do
    context "with valid params" do
      let(:valid_amenity_params) do
        {
          name: "Pool",
          image: Rack::Test::UploadedFile.new("spec/support/images/dog.jpg", "image/jpeg")
        }
      end

      subject { put admin_hotel_amenity_path(hotel, amenity), params: { amenity: valid_amenity_params } ; response }

      it { is_expected.to have_http_status :found }
      it { is_expected.to redirect_to admin_hotel_amenities_path(hotel) }
      it { expect { subject }.not_to change(Amenity, :count) }
      it "update the amenity with the correct attributes" do
        subject
        amenity = Amenity.last
        expect(amenity.name).to eq(valid_amenity_params[:name])
        expect(amenity.image).to be_attached
        expect(amenity.image.filename.to_s).to eq(valid_amenity_params[:image].original_filename)
      end
    end

    context "with invalid params" do
      let(:invalid_amenity_params) { FactoryBot.attributes_for(:amenity, :invalid_amenity) }
      subject { put admin_hotel_amenity_path(hotel, amenity), params: { amenity: invalid_amenity_params } ; response }

      it { is_expected.to have_http_status :unprocessable_entity }
      it { is_expected.to render_template :edit }
      it { subject; expect(assigns(:amenity)).to eq(amenity) }
      it { expect { subject }.not_to change(Amenity, :count) }
    end
  end

  describe "DELETE /destroy" do
    subject { delete admin_hotel_amenity_path(hotel, amenity); response }
    it { is_expected.to redirect_to admin_hotel_amenities_path }
    it { expect { subject }.to change(Amenity, :count).by(-1) }
  end
end
