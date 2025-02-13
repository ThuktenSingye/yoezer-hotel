# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Bookings', type: :request do
  let!(:hotel) { FactoryBot.create(:hotel) }
  let!(:room) { FactoryBot.create(:room, hotel: hotel) }
  let!(:booking) { FactoryBot.create(:booking, hotel: hotel) }

  before do
    subdomain hotel.subdomain
  end

  describe 'GET /new' do
    subject do
      get new_room_booking_path(room)
      response
    end

    it { is_expected.to have_http_status :ok }
  end

  describe 'POST /create' do
    context 'with valid params' do
      subject(:create_booking) do
        post room_bookings_path(room), params: { booking: valid_booking_params }
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

      it { expect { create_booking }.to change(Booking, :count).by(1) }

      it 'returns a JSON response with { ok: true }' do
        create_booking
        expect(response.parsed_body['ok']).to be true
      end

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
        post room_bookings_path(room), params: { booking: invalid_booking_params }
        response
      end

      let(:invalid_booking_params) { FactoryBot.attributes_for(:booking, :invalid_booking) }

      it { expect { create_booking }.not_to change(Booking, :count) }
      it { is_expected.to have_http_status :unprocessable_entity }
    end
  end

  describe 'GET /confirm' do
    context 'when confirmation token is present' do
      subject do
        get confirm_room_booking_path(room, booking, token: booking.confirmation_token)
        response
      end

      it { is_expected.to render_template('bookings/confirm') }
    end

    context 'when confirmation token is not present' do
      subject do
        get confirm_room_booking_path(room, booking)
        response
      end

      it { is_expected.to redirect_to room_path(room) }
    end
  end

  describe 'PATCH /update_confirmation' do
    subject(:update_confirmation) do
      patch update_confirmation_room_booking_path(room, booking, token: booking.confirmation_token)
      response
    end

    it 'update confirmed to true' do
      update_confirmation
      expect(Booking.last.confirmed).to be(true)
    end
  end


  describe 'DELETE /destroy' do
    subject(:delete_booking) do
      delete room_booking_path(room, booking)
      response
    end

    it { expect { delete_booking }.to change(Booking, :count).by(-1) }
  end
end
