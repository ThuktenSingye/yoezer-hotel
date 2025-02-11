# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Admins::Bookings', type: :request do
  let!(:hotel) { FactoryBot.create(:hotel) }
  let!(:admin) { FactoryBot.create(:admin) }
  let!(:room) { FactoryBot.create(:room, hotel: hotel) }
  let!(:booking) { FactoryBot.create(:booking, hotel: hotel) }

  before do
    sign_in admin, scope: :admin
  end

  describe 'GET /index' do
    subject do
      get admins_hotel_bookings_path(hotel)
      response
    end

    it { is_expected.to have_http_status :ok }
  end

  describe 'GET /new' do
    subject do
      get new_admins_hotel_room_booking_path(hotel, room)
      response
    end

    it { is_expected.to have_http_status :ok }
  end

  describe 'GET /show' do
    context 'when booking record exists' do
      subject do
        get admins_hotel_booking_path(hotel, booking)
        response
      end

      it { is_expected.to have_http_status :ok }
    end

    context 'when booking record does not exist' do
      subject do
        get admins_hotel_booking_path(hotel, booking.id + 1)
        response
      end

      it { is_expected.to redirect_to(admins_hotel_bookings_path(hotel)) }
    end
  end

  describe 'GET /edit' do
    subject do
      get edit_admins_hotel_booking_path(hotel, booking)
      response
    end

    it { is_expected.to have_http_status :ok }
  end

  describe 'PUT /update' do
    context 'with valid params' do
      subject(:update_booking) do
        put admins_hotel_booking_path(hotel, booking), params: { booking: valid_booking_params }
        response
      end

      let(:valid_booking_params) do
        {
          checkin_date: Faker::Date.backward(days: 14),
          checkout_date: Faker::Date.forward(days: 14),
          num_of_adult: Faker::Number.between(from: 1, to: 10),
          num_of_children: Faker::Number.between(from: 1, to: 10),
          payment_status: :pending,
          total_amount: Faker::Number.decimal(l_digits: 5),
          confirmed: false,
          room_id: room.id,
          guest_attributes: {
            first_name: Faker::Name.first_name,
            last_name: Faker::Name.last_name,
            contact_no: Faker::Number.number(digits: 8).to_s,
            email: Faker::Internet.email,
            country: Faker::Address.country,
            region: Faker::Address.state,
            city: Faker::Address.city,
            hotel_id: hotel.id
          }
        }
      end

      it { is_expected.to have_http_status :found }
      it { is_expected.to redirect_to admins_hotel_booking_path(hotel, booking) }
      it { expect { update_booking }.not_to change(Booking, :count) }

      # rubocop:disable RSpec/ExampleLength
      it 'update the booking with correct booking attributes' do
        update_booking
        expect(Booking.last).to have_attributes(
          num_of_adult: valid_booking_params[:num_of_adult],
          num_of_children: valid_booking_params[:num_of_children],
          payment_status: valid_booking_params[:payment_status].to_s,
          confirmed: valid_booking_params[:confirmed]
        )
        # rubocop:enable RSpec/ExampleLength
      end

      # rubocop:disable RSpec/MultipleExpectations, Layout/LineLength
      it 'update the booking with correct date' do
        update_booking
        expect(Booking.last.checkin_date.strftime('%d/%m/%Y')).to eq(valid_booking_params[:checkin_date].strftime('%d/%m/%Y'))
        expect(Booking.last.checkout_date.strftime('%d/%m/%Y')).to eq(valid_booking_params[:checkout_date].strftime('%d/%m/%Y'))
        # rubocop:enable RSpec/MultipleExpectations, Layout/LineLength
      end

      # rubocop:disable RSpec/ExampleLength
      it 'update the booking with correct guest' do
        update_booking
        expect(Booking.last.guest).to have_attributes(
          first_name: valid_booking_params[:guest_attributes][:first_name],
          last_name: valid_booking_params[:guest_attributes][:last_name],
          contact_no: valid_booking_params[:guest_attributes][:contact_no],
          email: valid_booking_params[:guest_attributes][:email],
          country: valid_booking_params[:guest_attributes][:country],
          region: valid_booking_params[:guest_attributes][:region],
          city: valid_booking_params[:guest_attributes][:city]
        )
        # rubocop:enable RSpec/ExampleLength
      end

      it 'associate with correct room' do
        update_booking
        expect(Booking.last.room.id).to eq(valid_booking_params[:room_id])
      end
    end

    context 'with invalid params' do
      subject(:update_booking) do
        put admins_hotel_booking_path(hotel, booking), params: { booking: invalid_booking_params }
        response
      end

      let(:invalid_booking_params) { FactoryBot.attributes_for(:booking, :invalid_booking) }

      it { is_expected.to have_http_status :unprocessable_entity }
      it { is_expected.to render_template :edit }
      it { expect { update_booking }.not_to change(Booking, :count) }
    end
  end

  describe 'POST /create' do
    context 'with valid params' do
      subject(:create_booking) do
        post admins_hotel_room_bookings_path(hotel, room), params: { booking: valid_booking_params }
        response
      end

      let(:valid_booking_params) do
        {
          checkin_date: Faker::Date.backward(days: 14),
          checkout_date: Faker::Date.forward(days: 14),
          num_of_adult: Faker::Number.between(from: 1, to: 10),
          num_of_children: Faker::Number.between(from: 1, to: 10),
          payment_status: :pending,
          total_amount: Faker::Number.decimal(l_digits: 5),
          confirmed: false,
          guest_attributes: {
            first_name: Faker::Name.first_name,
            last_name: Faker::Name.last_name,
            contact_no: Faker::Number.number(digits: 8).to_s,
            email: Faker::Internet.email,
            country: Faker::Address.country,
            region: Faker::Address.state,
            city: Faker::Address.city,
            hotel_id: hotel.id
          }
        }
      end

      it { is_expected.to have_http_status :found }
      it { is_expected.to redirect_to admins_hotel_room_path(hotel, room) }
      it { expect { create_booking }.to change(Booking, :count).by(1) }

      # rubocop:disable RSpec/ExampleLength
      it 'create the booking with correct booking attributes' do
        create_booking
        expect(Booking.last).to have_attributes(
          num_of_adult: valid_booking_params[:num_of_adult],
          num_of_children: valid_booking_params[:num_of_children],
          payment_status: valid_booking_params[:payment_status].to_s,
          confirmed: valid_booking_params[:confirmed]
        )
        # rubocop:enable RSpec/ExampleLength
      end

      # rubocop:disable RSpec/MultipleExpectations, Layout/LineLength
      it 'create the booking with correct date' do
        create_booking
        expect(Booking.last.checkin_date.strftime('%d/%m/%Y')).to eq(valid_booking_params[:checkin_date].strftime('%d/%m/%Y'))
        expect(Booking.last.checkout_date.strftime('%d/%m/%Y')).to eq(valid_booking_params[:checkout_date].strftime('%d/%m/%Y'))
        # rubocop:enable RSpec/MultipleExpectations, Layout/LineLength
      end

      # rubocop:disable RSpec/ExampleLength
      it 'create the booking with correct guest' do
        create_booking
        expect(Booking.last.guest).to have_attributes(
          first_name: valid_booking_params[:guest_attributes][:first_name],
          last_name: valid_booking_params[:guest_attributes][:last_name],
          contact_no: valid_booking_params[:guest_attributes][:contact_no],
          email: valid_booking_params[:guest_attributes][:email],
          country: valid_booking_params[:guest_attributes][:country],
          region: valid_booking_params[:guest_attributes][:region],
          city: valid_booking_params[:guest_attributes][:city]
        )
        # rubocop:enable RSpec/ExampleLength
      end
    end

    context 'with invalid params' do
      subject(:create_booking) do
        post admins_hotel_room_bookings_path(hotel, room), params: { booking: invalid_booking_params }
        response
      end

      let(:invalid_booking_params) { FactoryBot.attributes_for(:booking, :invalid_booking) }

      it { is_expected.to redirect_to admins_hotel_room_path(hotel, room) }
      it { expect { create_booking }.not_to change(Booking, :count) }
    end
  end

  describe 'DELETE /destroy' do
    context 'when payment status is completed' do
      subject(:delete_booking) do
        delete admins_hotel_booking_path(hotel, booking)
        response
      end

      it { is_expected.to redirect_to admins_hotel_bookings_path(hotel) }
      it { expect { delete_booking }.to change(Booking, :count).by(-1) }
    end

    context 'when payment status is other than completed' do
      subject(:delete_booking) do
        delete admins_hotel_booking_path(hotel, booking)
        response
      end

      before do
        booking.update(payment_status: 'pending')
      end

      it { is_expected.to redirect_to admins_hotel_bookings_path(hotel) }
      it { expect { delete_booking }.not_to change(Booking, :count) }
    end
  end
end
