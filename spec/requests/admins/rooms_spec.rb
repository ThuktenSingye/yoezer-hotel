# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Admins::Rooms', type: :request do
  let!(:hotel) { FactoryBot.create(:hotel) }
  let!(:admin) { FactoryBot.create(:admin) }
  let!(:room_category) { FactoryBot.create(:room_category, hotel: hotel) }
  let!(:room) { FactoryBot.create(:room, :with_room_image, :with_room_primary_image,room_category: room_category) }

  before do
    sign_in admin, scope: :admin
  end

  describe 'GET /index' do
    subject do
      get admins_hotel_rooms_path(hotel)
      response
    end

    it { is_expected.to have_http_status :ok }
  end

  describe 'GET /new' do
    subject do
      get new_admins_hotel_room_path(hotel)
      response
    end

    it { is_expected.to have_http_status :ok }
  end

  describe 'GET /show' do
    context 'when room record exists' do
      subject do
        get admins_hotel_room_path(hotel, room)
        response
      end

      it { is_expected.to have_http_status :ok }
    end

    context 'when room record does not exist' do
      subject do
        get admins_hotel_room_path(hotel, room.id + 1)
        response
      end

      it { is_expected.to redirect_to(admins_hotel_rooms_path(hotel)) }
    end
  end

  describe 'GET /edit' do
    subject do
      get edit_admins_hotel_room_path(hotel, room)
      response
    end

    it { is_expected.to have_http_status :ok }
  end

  describe 'UPDATE /update' do
    context 'with valid params' do
      subject(:update_room) do
        put admins_hotel_room_path(hotel, room), params: { room: valid_room_params }
        response
      end

      let(:valid_room_params) do
        {
          room_number: Faker::Number.unique.number(digits: 3).to_s,
          floor_number: Faker::Number.number(digits: 1),
          status: :booked,
          description: Faker::Lorem.sentence,
          max_no_adult: Faker::Number.number(digits: 2),
          max_no_children: Faker::Number.number(digits: 2),
          base_price: Faker::Number.decimal(l_digits: 5, r_digits: 2),
          room_category_id: room_category.id,
          primary_image: Rack::Test::UploadedFile.new('spec/support/images/cat.jpg', 'image/jpeg'),
          images: [
            Rack::Test::UploadedFile.new('spec/support/images/dog.jpg', 'image/jpeg'),
            Rack::Test::UploadedFile.new('spec/support/images/cat.jpg', 'image/jpeg')
          ]
        }
      end

      it { is_expected.to have_http_status :found }
      it { is_expected.to redirect_to admins_hotel_room_path(hotel, room) }
      it { expect { update_room }.not_to change(Room, :count) }

      it 'updates the room with the correct room number' do
        update_room
        expect(Room.last.room_number).to eq(valid_room_params[:room_number])
      end

      it 'updates the room with the correct floor number' do
        update_room
        expect(Room.last.floor_number).to eq(valid_room_params[:floor_number])
      end

      it 'updates the room with the correct status' do
        update_room
        expect(Room.last.status).to eq(valid_room_params[:status].to_s)
      end

      it 'updates the room with the correct base price' do
        update_room
        expect(Room.last.base_price).to eq(valid_room_params[:base_price])
      end

      it 'updates the room with the correct max number of adult' do
        update_room
        expect(Room.last.max_no_adult).to eq(valid_room_params[:max_no_adult])
      end

      it 'updates the room with the correct max number of children' do
        update_room
        expect(Room.last.max_no_children).to eq(valid_room_params[:max_no_children])
      end

      it 'attaches the correct primary image to the room' do
        update_room
        expect(Room.last.primary_image).to be_attached
      end

      it 'attaches the correct image to the room' do
        update_room
        expect(Room.last.images).to be_attached
      end
    end

    context 'with invalid params' do
      subject(:update_room) do
        put admins_hotel_room_path(hotel, room), params: { room: invalid_room_params }
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
        post admins_hotel_rooms_path(hotel), params: { room: valid_room_params }
        response
      end

      let(:valid_room_params) do
        {
          room_number: Faker::Number.unique.number(digits: 3).to_s,
          floor_number: Faker::Number.number(digits: 1),
          status: :booked,
          description: Faker::Lorem.sentence,
          max_no_adult: Faker::Number.number(digits: 2),
          max_no_children: Faker::Number.number(digits: 2),
          base_price: Faker::Number.decimal(l_digits: 5, r_digits: 2),
          room_category_id: room_category.id,
          primary_image: Rack::Test::UploadedFile.new('spec/support/images/cat.jpg', 'image/jpeg'),
          images: [
            Rack::Test::UploadedFile.new('spec/support/images/dog.jpg', 'image/jpeg'),
            Rack::Test::UploadedFile.new('spec/support/images/cat.jpg', 'image/jpeg')
          ]
        }
      end

      it { is_expected.to have_http_status :found }
      it { is_expected.to redirect_to admins_hotel_rooms_path(hotel) }
      it { expect { create_room }.to change(Room, :count).by(1) }

      it 'create the room with the correct room number' do
        create_room
        expect(Room.last.room_number).to eq(valid_room_params[:room_number])
      end

      it 'create the room with the correct floor number' do
        create_room
        expect(Room.last.floor_number).to eq(valid_room_params[:floor_number])
      end

      it 'create the room with the correct status' do
        create_room
        expect(Room.last.status).to eq(valid_room_params[:status].to_s)
      end

      it 'create the room with the correct base price' do
        create_room
        expect(Room.last.base_price).to eq(valid_room_params[:base_price])
      end

      it 'create the room with the correct max number of adult' do
        create_room
        expect(Room.last.max_no_adult).to eq(valid_room_params[:max_no_adult])
      end

      it 'create the room with the correct max number of children' do
        create_room
        expect(Room.last.max_no_children).to eq(valid_room_params[:max_no_children])
      end

      it 'attaches the primary image to the room' do
        create_room
        expect(Room.last.primary_image).to be_attached
      end

      it 'attaches the image to the room' do
        create_room
        expect(Room.last.images).to be_attached
      end
    end

    context 'with invalid params' do
      subject(:create_room) do
        post admins_hotel_rooms_path(hotel), params: { room: invalid_room_params }
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
      delete admins_hotel_room_path(hotel, room)
      response
    end

    it { is_expected.to redirect_to admins_hotel_rooms_path(hotel) }
    it { expect { delete_room }.to change(Room, :count).by(-1) }
  end
end
