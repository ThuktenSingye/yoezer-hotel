# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Profile, type: :model do
  context 'when validating attributes' do
    it { is_expected.to validate_presence_of(:first_name) }
    it { is_expected.to validate_presence_of(:cid_no) }
    it { is_expected.to validate_presence_of(:contact_no) }
  end

  context 'when associating models' do
    it { is_expected.to have_many :addresses }
    it { is_expected.to have_one_attached :avatar }
  end
end
