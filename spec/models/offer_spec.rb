# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Offer, type: :model do
  context 'when validating attributes' do
    it { is_expected.to validate_presence_of :title }
    it { is_expected.to validate_presence_of :description }
    it { is_expected.to validate_presence_of :start_time }
    it { is_expected.to validate_presence_of :end_time }
    it { is_expected.to validate_numericality_of(:discount).is_in(0..100) }
  end

  context 'when associating models' do
    it { is_expected.to belong_to :hotel }
    it { is_expected.to have_one_attached :image }
  end
end
