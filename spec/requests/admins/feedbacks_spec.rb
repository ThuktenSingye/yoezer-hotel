# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Admin::Feedbacks', type: :request do
  let!(:admin) { FactoryBot.create(:admin) }
  let!(:hotel) { FactoryBot.create(:hotel) }
  let!(:feedback) { FactoryBot.create(:feedback, hotel: hotel) }

  before do
    sign_in admin, scope: :admin
  end

  describe 'GET /index' do
    subject do
      get admins_hotel_feedbacks_path(hotel)
      response
    end

    it { is_expected.to have_http_status :ok }
  end

  describe 'GET /destroy' do
    subject(:delete_feedback) do
      delete admins_hotel_feedback_path(hotel, feedback)
      response
    end

    it { is_expected.to redirect_to admins_hotel_feedbacks_path(hotel) }
    it { expect { delete_feedback }.to change(Feedback, :count).by(-1) }
  end
end
