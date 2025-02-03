# frozen_string_literal: true

require 'rails_helper'

RSpec.describe HotelGallery, type: :model do
  context 'when validating attributes' do
    it { is_expected.to validate_presence_of :name }
    it { is_expected.to validate_presence_of :description }
  end

  context 'when associating models' do
    it { is_expected.to belong_to :hotel }
    it { is_expected.to have_one_attached :image }
  end
end
