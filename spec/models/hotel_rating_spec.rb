# frozen_string_literal: true

require 'rails_helper'

RSpec.describe HotelRating, type: :model do
  context 'when associating model' do
    it { is_expected.to belong_to :hotel }
    it { is_expected.to belong_to :guest }
  end
end
