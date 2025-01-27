# frozen_string_literal: true

require 'rails_helper'

RSpec.describe RoomBedType, type: :model do
  context 'when validating attributes' do
    it { is_expected.to validate_presence_of :num_of_bed }
    it { is_expected.to validate_presence_of :room_id }
    it { is_expected.to validate_presence_of :bed_type_id }
    it { is_expected.to validate_numericality_of(:num_of_bed).only_integer }
  end

  context 'when associating models' do
    it { is_expected.to belong_to :room }
    it { is_expected.to belong_to :bed_type }
  end
end
