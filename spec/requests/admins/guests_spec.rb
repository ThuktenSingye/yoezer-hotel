# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Admins::Guests', type: :request do
  let!(:admin) { FactoryBot.create(:admin) }
  let!(:hotel) { FactoryBot.create(:hotel) }
  let!(:guest) { FactoryBot.create(:guest, hotel: hotel) }

  before do
    sign_in admin, scope: :admin
    subdomain hotel.subdomain
  end

  describe 'GET /admins/hotels' do
    subject do
      get admins_guests_path
      response
    end

    it { is_expected.to have_http_status :ok }
  end

  describe 'GET /show' do
    context 'when guest record exists' do
      subject do
        get admins_guest_path(guest)
        response
      end

      it { is_expected.to have_http_status :ok }
    end

    context 'when guest record does not exist' do
      subject do
        get admins_guest_path(guest.id + 1)
        response
      end

      it { is_expected.to redirect_to admins_guests_path }
    end
  end

  describe 'GET /edit' do
    subject do
      get edit_admins_guest_path(guest)
      response
    end

    it { is_expected.to have_http_status :ok }
  end

  describe 'PUT /update' do
    context 'with valid params' do
      subject(:update_guest) do
        put admins_guest_path(guest), params: { guest: valid_guest_params }
        response
      end

      let(:valid_guest_params) { FactoryBot.attributes_for(:guest) }

      it { is_expected.to have_http_status :found }
      it { is_expected.to redirect_to admins_guest_path(guest) }
      it { expect { update_guest }.not_to change(Guest, :count) }

      # rubocop:disable RSpec/ExampleLength
      it 'updates the guest with the correct attributes' do
        update_guest
        expect(Guest.last).to have_attributes(
          first_name: valid_guest_params[:first_name],
          last_name: valid_guest_params[:last_name],
          email: valid_guest_params[:email],
          contact_no: valid_guest_params[:contact_no],
          country: valid_guest_params[:country],
          region: valid_guest_params[:region],
          city: valid_guest_params[:city]
        )
        # rubocop:enable RSpec/ExampleLength
      end
    end

    context 'with invalid params' do
      subject(:update_guest) do
        put admins_guest_path(guest), params: { guest: invalid_guest_params }
        response
      end

      let(:invalid_guest_params) { FactoryBot.attributes_for(:guest, :invalid_guest) }

      it { is_expected.to have_http_status(:unprocessable_entity) }
      it { is_expected.to render_template :edit }
      it { expect { update_guest }.not_to change(Guest, :count) }

      it 'assigns the correct guest' do
        update_guest
        expect(assigns(:guest)).to eq(guest)
      end
    end
  end
end
