# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Admins::Rooms', type: :request do
  let!(:hotel) { FactoryBot.create(:hotel) }
  let!(:admin) { FactoryBot.create(:admin) }
  let!(:room_category) { FactoryBot.create(:room_category, hotel: hotel) }
  let!(:room) { FactoryBot.create(:room, :with_room_image, room_category: room_category, hotel: hotel) }

  before do
    sign_in admin, scope: :admin
    subdomain hotel.subdomain
  end

  describe 'GET /index' do
    subject do
      get admins_rooms_path
      response
    end

    it { is_expected.to have_http_status :ok }
  end

  describe 'GET /new' do
    subject do
      get new_admins_room_path
      response
    end

    it { is_expected.to have_http_status :ok }
  end

  describe 'GET /show' do
    context 'when room record exists' do
      subject do
        get admins_room_path(room)
        response
      end

      it { is_expected.to have_http_status :ok }
    end

    context 'when room record does not exist' do
      subject do
        get admins_room_path(room.id + 1)
        response
      end

      it { is_expected.to redirect_to admins_rooms_path }
    end
  end

  describe 'GET /edit' do
    subject do
      get edit_admins_room_path(room)
      response
    end

    it { is_expected.to have_http_status :ok }
  end

  describe 'UPDATE /update' do
    context 'with valid params' do
      subject(:update_room) do
        put admins_room_path(room), params: { room: valid_room_params }
        response
      end

      let(:valid_room_params) do
        {
          room_number: Faker::Number.unique.number(digits: 3).to_s,
          floor_number: Faker::Number.number(digits: 1),
          status: :available,
          description: Faker::Lorem.sentence,
          max_no_adult: Faker::Number.number(digits: 2),
          max_no_children: Faker::Number.number(digits: 2),
          base_price: Faker::Number.decimal(l_digits: 5, r_digits: 2),
          room_category_id: room_category.id,
          image: Rack::Test::UploadedFile.new('spec/support/images/cat.jpg', 'image/jpeg'),
          images: [
            Rack::Test::UploadedFile.new('spec/support/images/dog.jpg', 'image/jpeg'),
            Rack::Test::UploadedFile.new('spec/support/images/cat.jpg', 'image/jpeg')
          ]
        }
      end

      it { is_expected.to have_http_status :found }
      it { is_expected.to redirect_to admins_room_path(room) }
      it { expect { update_room }.not_to change(Room, :count) }

      # rubocop:disable RSpec/ExampleLength, RSpec/MultipleExpectations
      it 'updates the room with correct attributes' do
        update_room
        expect(Room.last).to have_attributes(
          room_number: valid_room_params[:room_number],
          floor_number: valid_room_params[:floor_number],
          status: valid_room_params[:status].to_s,
          base_price: valid_room_params[:base_price],
          max_no_adult: valid_room_params[:max_no_adult],
          max_no_children: valid_room_params[:max_no_children]
        )
        expect(Room.last.image).to be_attached
        expect(Room.last.images).to be_attached
        # rubocop:enable RSpec/ExampleLength, RSpec/MultipleExpectations
      end
    end

    context 'with invalid params' do
      subject(:update_room) do
        put admins_room_path(room), params: { room: invalid_room_params }
        response
      end

      let(:invalid_room_params) do
        FactoryBot.attributes_for(:room, :invalid_room_params, hotel: hotel, room_category: room_category)
      end

      it { is_expected.to have_http_status :unprocessable_entity }
      it { is_expected.to render_template :edit }
      it { expect { update_room }.not_to change(Room, :count) }

      it 'assigns the original room' do
        update_room
        expect(assigns(:room)).to eq(room)
      end
    end
  end

  describe 'POST /create' do
    context 'with valid params' do
      subject(:create_room) do
        post admins_rooms_path, params: { room: valid_room_params }
        response
      end

      let(:valid_room_params) do
        {
          room_number: Faker::Number.unique.number(digits: 3).to_s,
          floor_number: Faker::Number.number(digits: 1),
          status: :available,
          description: Faker::Lorem.sentence,
          max_no_adult: Faker::Number.number(digits: 2),
          max_no_children: Faker::Number.number(digits: 2),
          base_price: Faker::Number.decimal(l_digits: 5, r_digits: 2),
          room_category_id: room_category.id,
          image: Rack::Test::UploadedFile.new('spec/support/images/cat.jpg', 'image/jpeg'),
          images: [
            Rack::Test::UploadedFile.new('spec/support/images/dog.jpg', 'image/jpeg'),
            Rack::Test::UploadedFile.new('spec/support/images/cat.jpg', 'image/jpeg')
          ]
        }
      end

      it { is_expected.to have_http_status :found }
      it { is_expected.to redirect_to admins_rooms_path }
      it { expect { create_room }.to change(Room, :count).by(1) }

      # rubocop:disable RSpec/ExampleLength, RSpec/MultipleExpectations
      it 'updates the room with correct attributes' do
        create_room
        expect(Room.last).to have_attributes(
          room_number: valid_room_params[:room_number],
          floor_number: valid_room_params[:floor_number],
          status: valid_room_params[:status].to_s,
          base_price: valid_room_params[:base_price],
          max_no_adult: valid_room_params[:max_no_adult],
          max_no_children: valid_room_params[:max_no_children]
        )
        expect(Room.last.image).to be_attached
        expect(Room.last.images).to be_attached
        # rubocop:enable RSpec/ExampleLength, RSpec/MultipleExpectations
      end
    end

    context 'with invalid params' do
      subject(:create_room) do
        post admins_rooms_path, params: { room: invalid_room_params }
        response
      end

      let(:invalid_room_params) do
        FactoryBot.attributes_for(:room, :invalid_room_params)
      end

      it { is_expected.to have_http_status :unprocessable_entity }
      it { is_expected.to render_template :new }
      it { expect { create_room }.not_to change(Room, :count) }
    end
  end

  describe 'DELETE /destroy' do
    subject(:delete_room) do
      delete admins_room_path(room)
      response
    end

    it { is_expected.to redirect_to admins_rooms_path }
    it { expect { delete_room }.to change(Room, :count).by(-1) }
  end
end
