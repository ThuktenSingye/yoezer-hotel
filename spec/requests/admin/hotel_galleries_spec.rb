require 'rails_helper'

RSpec.describe "Admin::HotelGalleries", type: :request do
  let!(:hotel) { FactoryBot.create(:hotel) }
  let!(:admin) { FactoryBot.create(:admin) }
  let!(:gallery) { FactoryBot.create(:hotel_gallery, :with_hotel_image, hotel: hotel) }

  describe "GET /index" do
    subject { get admin_hotel_galleries_path(hotel); response }
    it { is_expected.to have_http_status :ok }
  end

  describe "GET /new" do
    subject {get new_admin_hotel_gallery_path(hotel); response }
    it { is_expected.to have_http_status :ok }
  end

  describe "GET /show" do
    context "when gallery exists" do
      subject {get admin_hotel_gallery_path(hotel, gallery); response }
      it { is_expected.to have_http_status :ok }
    end

    context "when gallery record does not exist" do
      subject { get admin_hotel_gallery_path(hotel, gallery.id + 1); response }
      it { is_expected.to redirect_to(admin_hotel_hotel_galleries_path(hotel)) }
    end

  end

  describe "GET /edit" do
    subject { get edit_admin_hotel_gallery_path(hotel, gallery); response }
    it { is_expected.to have_http_status :ok }
  end

  describe "UPDATE /update" do
    context "with valid params" do
      let(:valid_hotel_gallery_params) do
        {
          hotel_name: Faker::Company.name,
          description: Faker::Lorem.sentence,
          images: [
            Rack::Test::UploadedFile.new("spec/support/images/dog.jpg", "image/jpeg"),
            Rack::Test::UploadedFile.new("spec/support/images/cat.jpg", "image/jpeg")
          ]
        }
      end
      subject { put admin_hotel_gallery_path(hotel, gallery), { params: { hotel_gallery: valid_hotel_gallery_params }}; response  }
      it { is_expected.to have_http_status :found }
      it { is_expected.to redirect_to admin_hotel_galleries_path(hotel) }
      it { expect { subject }.not_to change(HotelGallery, :count) }
      it "updates the hotel gallery" do
        subject
        hotel_gallery = HotelGallery.last
        expect(hotel_gallery.name). to eq(valid_hotel_gallery_params[:name])
        expect(hotel_gallery.description). to eq(valid_hotel_gallery_params[:name])
        expect(hotel_gallery.images). to eq(valid_hotel_gallery_params[:images])
      end
    end

    context "invalid params" do
      let(:invalid_hotel_gallery_params) { FactoryBot.attributes_for(:hotel_gallery, :invalid_hotel_gallery) }
      subject { put admin_hotel_gallery_path(hotel, gallery), { params: { hotel_gallery: invalid_hotel_gallery_params }}; response  }

      it { is_expected.to have_http_status :unprocessable_entity }
      it { is_expected.to render_template :edit }
      it { subject; expect(assigns(:gallery)).to eq(gallery) }
      it { expect { subject }.not_to change(HotelGallery, :count) }

    end
  end

  describe "GET /new" do
    subject { get new_admin_hotel_gallery_path(hotel); response }
    it { is_expected.to have_http_status :ok }
  end

  describe "POST /create" do
    context "with valid params" do
      let(:valid_hotel_gallery_params) do
        {
          hotel_name: Faker::Company.name,
          description: Faker::Lorem.sentence,
          images: [
            Rack::Test::UploadedFile.new("spec/support/images/dog.jpg", "image/jpeg"),
            Rack::Test::UploadedFile.new("spec/support/images/cat.jpg", "image/jpeg")
          ]
        }
      end
      subject { post admin_hotel_gallery_path(hotel), params: { hotel_gallery: valid_hotel_gallery_params }; response }

      it { is_expected.to have_http_status :found }
      it { is_expected.to redirect_to admin_hotel_galleries_path(hotel) }
      it { expect { subject }.to change(HotelGallery, :count).by(1) }
      it "create a hotel gallery with valid params" do
        subject
        gallery = HotelGallery.last
        expect(gallery.name).to eq(valid_hotel_gallery_params[:name])
        expect(gallery.description).to eq(valid_hotel_gallery_params[:description])
        expect(gallery.images.size).to eq(valid_hotel_gallery_params[:images].size)
      end
    end
    context "with invalid params" do
      let(:invalid_hotel_gallery_params) { FactoryBot.attributes_for(:hotel_gallery, :invalid_hotel_gallery) }
      subject { post admin_hotel_gallery_path(hotel), params: { hotel_gallery: invalid_hotel_gallery_params }; response }

      it { is_expected.to have_http_status :unprocessable_entity }
      it { is_expected.to render_template :new }
      it { expect { subject }.not_to change(HotelGallery, :count) }
    end
  end

  describe "DELETE /destroy" do
    subject { delete admin_hotel_gallery_path(hotel, gallery); response }
    it { is_expected.to have_http_status :ok }
  end
end
