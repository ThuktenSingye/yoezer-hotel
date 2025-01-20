require 'rails_helper'

RSpec.describe "Admin::Profiles", type: :request do
  let!(:admin) { FactoryBot.create(:admin) }
  let!(:profile) { FactoryBot.create(:profile, :with_avatar, profileable: admin) }

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
      let!(:valid_profile_params) do
        {
          first_name: Faker::Name.first_name,
          last_name: Faker::Name.last_name,
          cid_no: Faker::Number.number(digits: 11).to_s,
          designation: :manager,
          date_of_joining: Faker::Date.backward(days: 1),
          contact_no:  Faker::Number.number(digits: 8).to_s,
          salary: Faker::Number.decimal(l_digits: 5),
          dob: Faker::Date.birthday(min_age: 18, max_age: 65),
          qualification: Faker::Educator.degree,
          avatar: Rack::Test::UploadedFile.new("spec/support/images/cat.jpg", "image/jpeg")
        }
      end
      subject { put admin_profile_path(profile, params: { profile: valid_profile_params }); response }

      it { is_expected.to have_http_status :found }
      it { is_expected.to redirect_to admin_profiles_path }
      it { expect { subject }.not_to change(Profile, :count) }
      it "update profile with valid attributes" do
        subject
        profile.reload
        expect(profile.attributes.slice(*profile_attributes).merge('designation' => Profile.last.designation.to_sym)).to eq(valid_profile_params.stringify_keys.except('avatar'))
        expect(profile.avatar.filename.to_s).to eq(valid_profile_params[:avatar].original_filename)
        expect(profile.avatar.attached?).to eq(true)
      end
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
