# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Room, type: :model do
  context 'when validating attributes' do
    it { is_expected.to validate_presence_of :room_number }
    it { is_expected.to validate_presence_of :status }
    it { is_expected.to validate_presence_of :base_price }
    it { is_expected.to validate_presence_of :max_no_adult }
    it { is_expected.to validate_presence_of :max_no_children }
  end

  context 'when validating uniqueness of room_number' do
    subject { FactoryBot.build(:room, room_category: room_category) }

    let(:room_category) { FactoryBot.create(:room_category) }

    it { is_expected.to validate_uniqueness_of(:room_number).case_insensitive }
  end

  context 'when associating models' do
    it { is_expected.to belong_to :room_category }
    it { is_expected.to belong_to :hotel }
    it { is_expected.to have_one_attached :image }
    it { is_expected.to have_many(:bed_types).through(:room_bed_types).dependent(:destroy) }
    it { is_expected.to have_many(:facilities).through(:room_facilities).dependent(:destroy) }
  end
end
