# frozen_string_literal: true

require 'rails_helper'

# Spec for Expired Booking Cleanup
RSpec.describe BookingCleanupWorker, type: :job do
  describe '#perform' do
    let(:hotel) { FactoryBot.create(:hotel) }
    let!(:room) { FactoryBot.create(:room, hotel: hotel) }

    context 'when expired booking exist' do
      let!(:expired_booking) do
        FactoryBot.create(:booking, room: room, hotel: hotel)
      end

      it 'destroys expired bookings' do
        expect do
          described_class.new.perform(hotel.id, expired_booking.id)
        end.to change(Booking, :count).by(-1)
      end
    end

    context 'when active booking exist' do
      let!(:active_booking) { FactoryBot.create(:booking, :active_booking, room: room, hotel: hotel) }

      it 'does not destroys active bookings' do
        expect do
          described_class.new.perform(hotel.id, active_booking.id)
        end.not_to change(Booking, :count)
      end
    end

    context 'when correct job is assign queue' do
      it 'queues the job in the correct queue' do
        expect do
          described_class.perform_async
        end.to change(Sidekiq::Queues['booking_cleanup_queue'], :size).by(1)
      end
    end
  end
end
