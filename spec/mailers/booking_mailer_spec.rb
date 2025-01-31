# frozen_string_literal: true

require 'rails_helper'

RSpec.describe BookingMailer, type: :mailer do
  let!(:hotel) { FactoryBot.create(:hotel) }
  let!(:booking) { FactoryBot.create(:booking, hotel: hotel) }

  context 'when confirmation email is sent' do
    let!(:mail) { described_class.confirmation_email(booking) }

    it 'renders the headers' do
      expect(mail).to have_attributes(
        subject: 'Room Booking Confirmation Email',
        to: ['thuktensingye2163@gmail.com'],
        from: ['02210232.cst@rub.edu.bt']
      )
    end
  end

  context 'when success booking email is sent' do
    let!(:mail) { described_class.booking_success_email(booking) }

    it 'renders the headers' do
      expect(mail).to have_attributes(
        subject: 'Booking Confirmation Successful',
        to: ['thuktensingye2163@gmail.com'],
        from: ['02210232.cst@rub.edu.bt']
      )
    end
  end

  context 'when update booking email is sent' do
    let!(:mail) { described_class.booking_update_email(booking) }

    it 'renders the headers' do
      expect(mail).to have_attributes(
        subject: 'Booking Detail Update',
        to: ['thuktensingye2163@gmail.com'],
        from: ['02210232.cst@rub.edu.bt']
      )
    end
  end
end
