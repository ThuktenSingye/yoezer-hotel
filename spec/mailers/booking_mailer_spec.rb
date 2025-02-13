# frozen_string_literal: true

require 'rails_helper'

RSpec.describe BookingMailer, type: :mailer do
  let!(:hotel) { FactoryBot.create(:hotel) }
  let!(:booking) { FactoryBot.create(:booking, hotel: hotel) }

  context 'when confirmation email is sent' do
    subject(:confirm_email) { described_class.confirmation_email(hotel.id, booking.id).deliver_now }

    it 'has the correct attributes' do
      expect(confirm_email).to have_attributes(
        subject: I18n.t('booking.confirmation-email-subject'),
        to: [booking.guest.email],
        from: [hotel.email]
      )
    end

    it 'enqueues the confirmation email job' do
      expect do
        described_class.confirmation_email(hotel.id, booking.id).deliver_later(queue: 'mailers')
      end.to change { Sidekiq::Worker.jobs.size }.by(1)
    end
  end

  context 'when success booking email is sent' do
    subject(:success_email) { described_class.booking_success_email(hotel.id, booking.id).deliver_now }

    it 'has the correct attributes' do
      expect(success_email).to have_attributes(
        subject: I18n.t('booking.success-email-subject'),
        to: [booking.guest.email],
        from: [hotel.email]
      )
    end

    it 'enqueues the success booking email job' do
      expect do
        described_class.booking_success_email(hotel.id, booking.id).deliver_later(queue: 'mailers')
      end.to change { Sidekiq::Worker.jobs.size }.by(1)
    end
  end

  context 'when update booking email is sent' do
    subject(:update_email) { described_class.booking_update_email(hotel.id, booking.id).deliver_now }

    it 'has the correct attributes' do
      expect(update_email).to have_attributes(
        subject: I18n.t('booking.update-email-subject'),
        to: [booking.guest.email],
        from: [hotel.email]
      )
    end

    it 'enqueues the update booking email job' do
      expect do
        described_class.booking_update_email(booking).deliver_later(queue: 'mailers')
      end.to change { Sidekiq::Worker.jobs.size }.by(1)
    end
  end
end
