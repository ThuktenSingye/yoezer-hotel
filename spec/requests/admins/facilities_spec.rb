# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Admins::Facilities', type: :request do
  let!(:admin) { FactoryBot.create(:admin) }
  let!(:hotel) { FactoryBot.create(:hotel) }
  let!(:facility) { FactoryBot.create(:facility, :with_facility_image, hotel: hotel) }

  before do
    sign_in admin, scope: :admin
    subdomain hotel.subdomain
  end

  describe 'GET /index' do
    subject do
      get admins_facilities_path
      response
    end

    it { is_expected.to have_http_status :ok }
  end

  describe 'GET /new' do
    subject do
      get new_admins_facility_path
      response
    end

    it { is_expected.to have_http_status :ok }
  end

  describe 'POST /create' do
    context 'with valid params' do
      subject(:create_facility) do
        post admins_facilities_path, params: { facility: valid_facility_params }
        response
      end

      let(:valid_facility_params) do
        {
          name: 'Pool',
          image: Rack::Test::UploadedFile.new('spec/support/images/dog.jpg', 'image/jpeg')
        }
      end

      it { is_expected.to have_http_status :found }
      it { is_expected.to redirect_to admins_facilities_path }
      it { expect { create_facility }.to change(Facility, :count).by(1) }

      # rubocop:disable RSpec/MultipleExpectations
      it 'creates the facility with the correct attributes' do
        create_facility
        expect(Facility.last.name).to eq(valid_facility_params[:name])
        expect(Facility.last.image).to be_attached
        expect(Facility.last.image.filename.to_s).to eq(valid_facility_params[:image].original_filename)
        # rubocop:enable RSpec/MultipleExpectations
      end
    end

    context 'with invalid params' do
      subject(:create_facility) do
        post admins_facilities_path, params: { facility: invalid_facility_params }
        response
      end

      let(:invalid_facility_params) { FactoryBot.attributes_for(:facility, :invalid_facility) }

      it { is_expected.to have_http_status :unprocessable_entity }
      it { is_expected.to render_template :new }
      it { expect { create_facility }.not_to change(Facility, :count) }
    end
  end

  describe 'GET /edit' do
    subject do
      get edit_admins_facility_path(facility)
      response
    end

    it { is_expected.to have_http_status :ok }
  end

  describe 'put /update' do
    context 'with valid params' do
      subject(:update_facility) do
        put admins_facility_path(facility), params: { facility: valid_facility_params }
        response
      end

      let(:valid_facility_params) do
        {
          name: 'Pool',
          image: Rack::Test::UploadedFile.new('spec/support/images/dog.jpg', 'image/jpeg')
        }
      end

      it { is_expected.to have_http_status :found }
      it { is_expected.to redirect_to admins_facilities_path }
      it { expect { update_facility }.not_to change(Facility, :count) }

      # rubocop:disable RSpec/MultipleExpectations
      it 'updates the facility with the correct name' do
        update_facility
        expect(Facility.last.name).to eq(valid_facility_params[:name])
        expect(Facility.last.image).to be_attached
        expect(Facility.last.image.filename.to_s).to eq(valid_facility_params[:image].original_filename)
        # rubocop:enable RSpec/MultipleExpectations
      end
    end

    context 'with invalid params' do
      subject(:update_facility) do
        put admins_facility_path(facility), params: { facility: invalid_facility_params }
        response
      end

      let(:invalid_facility_params) { FactoryBot.attributes_for(:facility, :invalid_facility) }

      it { is_expected.to have_http_status :unprocessable_entity }
      it { is_expected.to render_template :edit }
      it { expect { update_facility }.not_to change(Facility, :count) }

      it 'assigns the correct facility' do
        update_facility
        expect(assigns(:facility)).to eq(facility)
      end
    end
  end

  describe 'DELETE /destroy' do
    subject(:delete_facility) do
      delete admins_facility_path(facility)
      response
    end

    it { is_expected.to redirect_to admins_facilities_path }
    it { expect { delete_facility }.to change(Facility, :count).by(-1) }
  end
end
