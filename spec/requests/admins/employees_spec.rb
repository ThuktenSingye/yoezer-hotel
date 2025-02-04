# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Admins::Employees', type: :request do
  let!(:hotel) { FactoryBot.create(:hotel) }
  let!(:admin) { FactoryBot.create(:admin) }
  let!(:employee) { FactoryBot.create(:employee, hotel: hotel) }

  before do
    sign_in admin, scope: :admin
  end

  describe 'GET /index' do
    subject do
      get admins_hotel_employees_path(hotel)
      response
    end

    it { is_expected.to have_http_status :ok }
  end

  describe 'GET /new' do
    subject do
      get new_admins_hotel_employee_path(hotel)
      response
    end

    it { is_expected.to have_http_status :ok }
  end

  describe 'GET /show' do
    context 'when employee record exists' do
      subject do
        get admins_hotel_employee_path(hotel, employee)
        response
      end

      it { is_expected.to have_http_status :ok }
    end

    context 'when employee record does not exist' do
      subject do
        get admins_hotel_employee_path(hotel, employee.id + 1)
        response
      end

      it { is_expected.to redirect_to(admins_hotel_employees_path(hotel)) }
    end
  end

  describe 'GET /edit' do
    subject do
      get edit_admins_hotel_employee_path(hotel, employee)
      response
    end

    it { is_expected.to have_http_status :ok }
  end

  describe 'UPDATE /update' do
    context 'with valid params' do
      subject(:update_employee) do
        put admins_hotel_employee_path(hotel, employee), params: { employee: valid_employee_params }
        response
      end

      let(:valid_employee_params) do
        {
          email: Faker::Internet.email,
          documents: [
            Rack::Test::UploadedFile.new('spec/support/images/dog.jpg', 'image/jpeg'),
            Rack::Test::UploadedFile.new('spec/support/images/cat.jpg', 'image/jpeg')
          ],
          profile_attributes: {
            first_name: Faker::Name.first_name,
            last_name: Faker::Name.last_name,
            cid_no: Faker::Number.number(digits: 11).to_s,
            designation: :manager,
            date_of_joining: Faker::Date.backward(days: 1),
            contact_no: Faker::Number.number(digits: 8).to_s,
            salary: Faker::Number.decimal(l_digits: 5),
            dob: Faker::Date.birthday(min_age: 18, max_age: 65),
            qualification: Faker::Educator.degree,
            avatar: Rack::Test::UploadedFile.new('spec/support/images/dog.jpg', 'image/jpeg'),
            addresses_attributes: [
              {
                dzongkhag: Faker::Address.state,
                gewog: Faker::Address.city,
                street_address: Faker::Address.street_address,
                address_type: :present
              },
              {
                dzongkhag: Faker::Address.state,
                gewog: Faker::Address.city,
                street_address: Faker::Address.street_address,
                address_type: :permanent
              }
            ]
          }
        }
      end

      it { is_expected.to have_http_status :found }
      it { is_expected.to redirect_to admins_hotel_employee_path(hotel, employee) }
      it { expect { update_employee }.not_to change(Room, :count) }

      # rubocop:disable RSpec/MultipleExpectations
      it 'updates the employee with correct employee attributes' do
        update_employee
        expect(Employee.last.email).to eq(valid_employee_params[:email])
        expect(Employee.last.documents).to be_attached
        # rubocop:enable RSpec/MultipleExpectations
      end

      # rubocop:disable RSpec/ExampleLength
      it 'updates the employee with correct profile attributes' do
        update_employee
        expect(Employee.last.profile).to have_attributes(
          first_name: valid_employee_params[:profile_attributes][:first_name],
          last_name: valid_employee_params[:profile_attributes][:last_name],
          cid_no: valid_employee_params[:profile_attributes][:cid_no],
          designation: valid_employee_params[:profile_attributes][:designation].to_s,
          date_of_joining: valid_employee_params[:profile_attributes][:date_of_joining],
          contact_no: valid_employee_params[:profile_attributes][:contact_no],
          salary: valid_employee_params[:profile_attributes][:salary],
          dob: valid_employee_params[:profile_attributes][:dob],
          qualification: valid_employee_params[:profile_attributes][:qualification]
        )
        # rubocop:enable RSpec/ExampleLength
      end

      # rubocop:disable RSpec/ExampleLength
      it 'updates the employee with correct address attributes' do
        update_employee
        expect(Employee.last.profile.addresses.first).to have_attributes(
          dzongkhag: valid_employee_params[:profile_attributes][:addresses_attributes].first[:dzongkhag],
          gewog: valid_employee_params[:profile_attributes][:addresses_attributes].first[:gewog],
          street_address: valid_employee_params[:profile_attributes][:addresses_attributes].first[:street_address],
          address_type: valid_employee_params[:profile_attributes][:addresses_attributes].first[:address_type].to_s
        )
        # rubocop:enable RSpec/ExampleLength
      end
    end

    context 'with invalid params' do
      subject(:update_employee) do
        put admins_hotel_employee_path(hotel, employee), params: { employee: invalid_employee_params }
        response
      end

      let(:invalid_employee_params) do
        {
          email: nil,
          documents: [
            Rack::Test::UploadedFile.new('spec/support/images/dog.jpg', 'image/jpeg'),
            Rack::Test::UploadedFile.new('spec/support/images/cat.jpg', 'image/jpeg')
          ],
          profile_attributes: {
            first_name: nil,
            last_name: Faker::Name.last_name,
            cid_no: nil,
            designation: :manager,
            date_of_joining: Faker::Date.backward(days: 1),
            contact_no: nil,
            salary: Faker::Number.decimal(l_digits: 5),
            dob: Faker::Date.birthday(min_age: 18, max_age: 65),
            qualification: Faker::Educator.degree
          }
        }
      end

      it { is_expected.to have_http_status :unprocessable_entity }
      it { is_expected.to render_template :edit }
      it { expect { update_employee }.not_to change(Employee, :count) }

      it 'assigns the original employee' do
        update_employee
        expect(assigns(:employee)).to eq(employee)
      end
    end
  end

  describe 'POST /create' do
    context 'with valid params' do
      subject(:create_employee) do
        post admins_hotel_employees_path(hotel), params: { employee: valid_employee_params }
        response
      end

      let(:valid_employee_params) do
        {
          email: Faker::Internet.email,
          documents: [
            Rack::Test::UploadedFile.new('spec/support/images/dog.jpg', 'image/jpeg'),
            Rack::Test::UploadedFile.new('spec/support/images/cat.jpg', 'image/jpeg')
          ],
          profile_attributes: {
            first_name: Faker::Name.first_name,
            last_name: Faker::Name.last_name,
            cid_no: Faker::Number.number(digits: 11).to_s,
            designation: :manager,
            date_of_joining: Faker::Date.backward(days: 1),
            contact_no: Faker::Number.number(digits: 8).to_s,
            salary: Faker::Number.decimal(l_digits: 5),
            dob: Faker::Date.birthday(min_age: 18, max_age: 65),
            qualification: Faker::Educator.degree,
            avatar: Rack::Test::UploadedFile.new('spec/support/images/dog.jpg', 'image/jpeg'),
            addresses_attributes: [
              {
                dzongkhag: Faker::Address.state,
                gewog: Faker::Address.city,
                street_address: Faker::Address.street_address,
                address_type: :present
              },
              {
                dzongkhag: Faker::Address.state,
                gewog: Faker::Address.city,
                street_address: Faker::Address.street_address,
                address_type: :permanent
              }
            ]
          }
        }
      end

      it { is_expected.to have_http_status :found }
      it { is_expected.to redirect_to admins_hotel_employees_path(hotel) }
      it { expect { create_employee }.to change(Employee, :count).by(1) }

      # rubocop:disable RSpec/MultipleExpectations
      it 'create the employee with correct employee attributes' do
        create_employee
        expect(Employee.last.email).to eq(valid_employee_params[:email])
        expect(Employee.last.documents).to be_attached
        # rubocop:enable RSpec/MultipleExpectations
      end

      # rubocop:disable RSpec/ExampleLength
      it 'create the employee with correct profile attributes' do
        create_employee
        expect(Employee.last.profile).to have_attributes(
          first_name: valid_employee_params[:profile_attributes][:first_name],
          last_name: valid_employee_params[:profile_attributes][:last_name],
          cid_no: valid_employee_params[:profile_attributes][:cid_no],
          designation: valid_employee_params[:profile_attributes][:designation].to_s,
          date_of_joining: valid_employee_params[:profile_attributes][:date_of_joining],
          contact_no: valid_employee_params[:profile_attributes][:contact_no],
          salary: valid_employee_params[:profile_attributes][:salary],
          dob: valid_employee_params[:profile_attributes][:dob],
          qualification: valid_employee_params[:profile_attributes][:qualification]
        )
        # rubocop:enable RSpec/ExampleLength
      end

      # rubocop:disable RSpec/ExampleLength
      it 'create the employee with correct address attributes' do
        create_employee
        expect(Employee.last.profile.addresses.first).to have_attributes(
          dzongkhag: valid_employee_params[:profile_attributes][:addresses_attributes].first[:dzongkhag],
          gewog: valid_employee_params[:profile_attributes][:addresses_attributes].first[:gewog],
          street_address: valid_employee_params[:profile_attributes][:addresses_attributes].first[:street_address],
          address_type: valid_employee_params[:profile_attributes][:addresses_attributes].first[:address_type].to_s
        )
        # rubocop:enable RSpec/ExampleLength
      end
    end

    context 'with invalid params' do
      subject(:create_employee) do
        post admins_hotel_employees_path(hotel), params: { employee: invalid_employee_params }
        response
      end

      let(:invalid_employee_params) do
        {
          email: nil,
          documents: [
            Rack::Test::UploadedFile.new('spec/support/images/dog.jpg', 'image/jpeg'),
            Rack::Test::UploadedFile.new('spec/support/images/cat.jpg', 'image/jpeg')
          ],
          profile_attributes: {
            first_name: nil,
            last_name: Faker::Name.last_name,
            cid_no: nil,
            designation: :manager,
            date_of_joining: Faker::Date.backward(days: 1),
            contact_no: nil,
            salary: Faker::Number.decimal(l_digits: 5),
            dob: Faker::Date.birthday(min_age: 18, max_age: 65),
            qualification: Faker::Educator.degree
          }
        }
      end

      it { is_expected.to have_http_status :unprocessable_entity }
      it { is_expected.to render_template :new }
      it { expect { create_employee }.not_to change(Employee, :count) }
    end
  end

  describe 'DELETE /destroy' do
    subject(:delete_employee) do
      delete admins_hotel_employee_path(hotel, employee)
      response
    end

    it { is_expected.to redirect_to admins_hotel_employees_path(hotel) }
    it { expect { delete_employee }.to change(Employee, :count).by(-1) }
  end
end
