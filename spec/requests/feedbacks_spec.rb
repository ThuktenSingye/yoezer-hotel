# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Feedbacks', type: :request do
  let(:admin) { FactoryBot.create(:admin) }
  let(:hotel) { FactoryBot.create(:hotel) }
  let(:feedback) { FactoryBot.create(:feedback) }

  before do
    subdomain hotel.subdomain
  end

  describe 'GET /index' do
    subject do
      get admins_feedbacks_path
      response
    end

    it { is_expected.to have_http_status :found }
  end

  describe 'POST /create' do
    context 'with valid params' do
      subject(:create_feedback) do
        post feedbacks_path, params: { feedback: valid_feedback_params }
        response
      end

      let(:valid_feedback_params) do
        {
          name: Faker::Lorem.word,
          email: Faker::Internet.email,
          feedback: Faker::Lorem.sentence
        }
      end

      it { is_expected.to have_http_status :found }
      it { expect { create_feedback }.to change(Feedback, :count).by(1) }
    end

    context 'with invalid params' do
      subject(:create_feedback) do
        post feedbacks_path, params: { feedback: invalid_feedback_params }
        response
      end

      let(:invalid_feedback_params) { FactoryBot.attributes_for(:feedback, :invalid_feedback) }

      it { expect { create_feedback }.not_to change(Feedback, :count) }
    end
  end
end
