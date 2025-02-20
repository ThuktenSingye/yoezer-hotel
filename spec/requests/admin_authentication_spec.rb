# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Authentication', type: :request do
  let!(:valid_admin) { FactoryBot.create(:admin) }
  let(:hotel) { FactoryBot.create(:hotel) }

  before do
    subdomain hotel.subdomain
  end

  describe 'Log In' do
    context 'with correct credentials' do
      subject do
        post admin_session_path, params: { admin: valid_admin_params }
        response
      end

      let(:valid_admin_params) { { email: valid_admin.email, password: valid_admin.password } }

      it { is_expected.to redirect_to admin_root_path }
    end

    context 'with incorrect credentials' do
      subject do
        post admin_session_path, params: { admin: invalid_admin_params }
        response
      end

      let(:invalid_admin_params) { { email: 'wrong@example.com', password: 'wrongpassword' } }

      it { is_expected.to have_http_status :unprocessable_entity }
    end
  end
end
