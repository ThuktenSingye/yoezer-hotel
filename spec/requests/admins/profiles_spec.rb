# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Admin::Profiles', type: :request do
  let!(:admin) { FactoryBot.create(:admin) }
  let!(:hotel) { FactoryBot.create(:hotel) }
  let!(:profile) { FactoryBot.create(:profile, :with_avatar, profileable: admin) }

  before do
    sign_in admin, scope: :admin
  end

  describe 'GET /index' do
    subject do
      get admins_profiles_path(hotel)
      response
    end

    it { is_expected.to have_http_status :ok }
  end

  describe 'GET /edit' do
    subject do
      get edit_admins_profile_path(profile)
      response
    end

    it { is_expected.to have_http_status :ok }
  end

  describe 'PUT /update' do
    let(:profile_attributes) do
      %w[first_name last_name designation date_of_joining contact_no salary dob qualification cid_no]
    end

    context 'with valid params' do
      subject(:update_profile) do
        put admins_profile_path(profile, params: { profile: valid_profile_params })
        response
      end

      let!(:valid_profile_params) do
        {
          first_name: Faker::Name.first_name,
          last_name: Faker::Name.last_name,
          cid_no: Faker::Number.number(digits: 11).to_s,
          designation: :manager,
          date_of_joining: Faker::Date.backward(days: 1),
          contact_no: Faker::Number.number(digits: 8).to_s,
          salary: Faker::Number.decimal(l_digits: 5),
          dob: Faker::Date.birthday(min_age: 18, max_age: 65),
          qualification: Faker::Educator.degree,
          avatar: Rack::Test::UploadedFile.new('spec/support/images/cat.jpg', 'image/jpeg')
        }
      end

      it { is_expected.to have_http_status :found }
      it { is_expected.to redirect_to admins_profiles_path }
      it { expect { update_profile }.not_to change(Profile, :count) }

      it 'updates first name correctly' do
        update_profile
        expect(Profile.last.first_name).to eq(valid_profile_params[:first_name])
      end

      it 'updates last name correctly' do
        update_profile
        expect(Profile.last.last_name).to eq(valid_profile_params[:last_name])
      end

      it 'updates designation correctly' do
        update_profile
        expect(Profile.last.designation).to eq(valid_profile_params[:designation].to_s)
      end

      it 'updates date of joining correctly' do
        update_profile
        expect(Profile.last.date_of_joining).to eq(valid_profile_params[:date_of_joining])
      end

      it 'updates contact number correctly' do
        update_profile
        expect(Profile.last.contact_no).to eq(valid_profile_params[:contact_no])
      end

      it 'updates salary correctly' do
        update_profile
        expect(Profile.last.salary.to_s).to eq(valid_profile_params[:salary].to_s)
      end

      it 'updates date of birth correctly' do
        update_profile
        expect(Profile.last.dob).to eq(valid_profile_params[:dob])
      end

      it 'updates qualification correctly' do
        update_profile
        expect(Profile.last.qualification).to eq(valid_profile_params[:qualification])
      end

      it 'updates CID number correctly' do
        update_profile
        expect(Profile.last.cid_no).to eq(valid_profile_params[:cid_no])
      end

      it 'attaches the correct avatar filename' do
        update_profile
        expect(Profile.last.avatar.filename.to_s).to eq(valid_profile_params[:avatar].original_filename)
      end

      it 'attaches the avatar' do
        update_profile
        expect(Profile.last.avatar).to be_attached
      end
    end

    context 'with invalid params' do
      subject(:update_profile) do
        put admins_profile_path(profile), params: { profile: invalid_profile_params }
        response
      end

      let(:invalid_profile_params) { FactoryBot.attributes_for(:profile, :with_invalid_params) }

      it { is_expected.to have_http_status :unprocessable_entity }
      it { expect { update_profile }.not_to(change { profile.reload.attributes.slice(*profile_attributes) }) }
      it { expect { update_profile }.not_to change(Profile, :count) }

      it 'assigns the correct profile' do
        update_profile
        expect(assigns(:profile)).to eq(profile)
      end
    end
  end
end
