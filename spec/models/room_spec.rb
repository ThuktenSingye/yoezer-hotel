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
    subject { FactoryBot.build(:room) }

    it { is_expected.to validate_uniqueness_of(:room_number).case_insensitive }
  end

  context 'when associating models' do
    it { is_expected.to belong_to :room_category }
    it { is_expected.to belong_to :hotel }
  end
end
