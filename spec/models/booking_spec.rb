# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Booking, type: :model do
  context 'when validating attributes' do
    it { is_expected.to validate_presence_of :checkin_date }
    it { is_expected.to validate_presence_of :checkout_date }
    it { is_expected.to validate_presence_of :num_of_adult }
    it { is_expected.to validate_presence_of :num_of_children }
  end

  context 'when associating models' do
    it { is_expected.to belong_to :room }
    it { is_expected.to belong_to :guest }
  end
end
