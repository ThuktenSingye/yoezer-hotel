# frozen_string_literal: true

require 'rails_helper'

RSpec.describe HotelRating, type: :model do
  context 'when validating attributes' do
    it { is_expected.to validate_presence_of :rating }
    it { is_expected.to validate_numericality_of(:rating).is_in(0..5) }
  end

  context 'when associating model' do
    it { is_expected.to belong_to :hotel }
    it { is_expected.to belong_to :guest }
  end
end
