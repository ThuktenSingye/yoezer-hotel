require 'rails_helper'

RSpec.describe RoomBedType, type: :model do
  context 'when associating models' do
    it { is_expected.to belong_to :room }
    it { is_expected.to belong_to :bed_type }
  end
end
