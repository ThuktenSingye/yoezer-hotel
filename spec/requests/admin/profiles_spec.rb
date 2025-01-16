require 'rails_helper'

RSpec.describe "Admin::Profiles", type: :request do
  let!(:admin) { FactoryBot.create(:admin) }
  let!(:profile) { FactoryBot.create(:profile, profileable: admin) }

  before do
    sign_in admin, scope: :admin
  end

  describe "GET /index" do
    subject { get admin_profiles_path; response }
    it { should have_http_status :ok }
  end

  describe "GET /edit" do
    subject { get edit_admin_profile_path(profile); response }
    it { should have_http_status :ok }
  end

  describe "PUT /update" do
    let(:profile_attributes) { %w[first_name last_name designation date_of_joining contact_no salary dob qualification cid_no ] }
    context "with valid params" do
      let!(:valid_profile_params)  { FactoryBot.attributes_for(:profile) }
      subject { put admin_profile_path(profile, params: { profile: valid_profile_params }); response }

      it { is_expected.to have_http_status :found }
      it { is_expected.to redirect_to admin_profiles_path }
      it { expect { subject }.not_to change(Profile, :count) }
      it { subject; profile.reload; expect(profile.attributes.slice(*profile_attributes).merge('designation' => Profile.last.designation.to_sym)).to eq(valid_profile_params.stringify_keys) }
    end


    context "with invalid params" do
      let(:invalid_profile_params) { FactoryBot.attributes_for(:profile, :with_invalid_params) }
      subject { put admin_profile_path(profile), params: { profile: invalid_profile_params }; response }

      it { is_expected.to have_http_status :unprocessable_entity }
      it { subject; expect(assigns(:profile)).to eq(profile) }
      it { expect { subject }.not_to change { profile.reload.attributes.slice(*profile_attributes) } }
      it { expect { subject }.not_to change(Profile, :count) }
    end
  end
end
