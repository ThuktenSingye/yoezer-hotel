require 'rails_helper'

RSpec.describe Facility, type: :model do
  context 'when validating attributes' do
    it { is_expected.to validate_presence_of :name }
  end

  context 'when validating uniqueness of name' do
    subject { FactoryBot.build(:facility) }

    it { is_expected.to validate_uniqueness_of(:name).case_insensitive }
  end

  context 'when associating models' do
    it { is_expected.to have_one_attached :image }
  end
end
