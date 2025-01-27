# frozen_string_literal: true

require 'rails_helper'

RSpec.describe RoomFacility, type: :model do
  context 'when validating attributes' do
    it { is_expected.to validate_presence_of :room_id }
    it { is_expected.to validate_presence_of :facility_id }
  end

  context 'when associating models' do
    it { is_expected.to belong_to :room }
    it { is_expected.to belong_to :facility }
  end
end
