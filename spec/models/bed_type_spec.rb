require 'rails_helper'

RSpec.describe BedType, type: :model do
  context 'when validating attributes' do
    it { is_expected.to validate_presence_of :name }
    it { is_expected.to validate_uniqueness_of :name }
  end

  context 'when associating models' do
    it { is_expected.to have_many(:room_bed_types).dependent(:nullify) }
  end
end
