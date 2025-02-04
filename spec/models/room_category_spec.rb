# frozen_string_literal: true

require 'rails_helper'

RSpec.describe RoomCategory, type: :model do
  context 'when validating attributes' do
    it { is_expected.to validate_presence_of :name }
    it { is_expected.to validate_uniqueness_of :name }
  end

  context 'when associating models' do
    it { is_expected.to belong_to :hotel }
  end
end
