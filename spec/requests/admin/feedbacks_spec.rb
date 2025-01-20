require 'rails_helper'

RSpec.describe "Admin::Feedbacks", type: :request do
  let!(:admin) { FactoryBot.create(:admin) }
  let!(:hotel) { FactoryBot.create(:hotel) }
  let!(:feedback) { FactoryBot.create(:feedback, hotel: hotel) }

  before do
    sign_in admin, scope: :admin
  end

  describe "GET /index" do
    subject { get admin_hotel_feedbacks_path(hotel); response }
    it { is_expected.to have_http_status :ok }
  end

  describe "GET /destroy" do
    subject { delete admin_hotel_feedback_path(hotel, feedback); response }
    it { is_expected.to redirect_to admin_hotel_feedbacks_path(hotel) }
    it { expect { subject }.to change(Feedback, :count).by(-1) }
  end
end
