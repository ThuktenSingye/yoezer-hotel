require 'rails_helper'

RSpec.describe BookingCleanupJob, type: :job do

  describe '#perform' do
    let(:hotel) { FactoryBot.create(:hotel)}

    context 'when expired booking exist' do
      let!(:expired_booking) { FactoryBot.create(:booking, checkout_date: 1.day.ago, hotel: hotel) }

      it 'destroys expired bookings' do
        expect {
          BookingCleanupJob.new.perform
        }.to change(Booking, :count).by(-1)
      end
    end

    context 'when active booking exist' do
      let!(:active_booking) { FactoryBot.create(:booking, checkout_date: 1.day.from_now, hotel: hotel) }

      it 'does not destroys active bookings' do
        expect {
          BookingCleanupJob.new.perform
        }.not_to change(Booking, :count)
      end
    end

    context 'when correct job is assign queue' do
      it 'queues the job in the correct queue' do
        expect {
          BookingCleanupJob.perform_async
        }.to change(Sidekiq::Queues['booking_cleanup_queue'], :size).by(1)
      end
    end
  end
end