# frozen_string_literal: true

require 'rails_helper'

RSpec.describe RoomRating, type: :model do
  context 'when associating models' do
    it { is_expected.to belong_to :room }
  end
end
