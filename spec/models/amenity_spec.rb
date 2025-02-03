# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Amenity, type: :model do
  context 'when validating attributes' do
    it { is_expected.to validate_presence_of :name }
  end

  context 'when associating models' do
    it { is_expected.to have_one_attached :image }
  end
end
