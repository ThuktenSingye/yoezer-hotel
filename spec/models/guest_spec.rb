# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Guest, type: :model do
  context 'when validating attributes' do
    it { is_expected.to validate_presence_of :first_name }
    it { is_expected.to validate_presence_of :contact_no }
    it { is_expected.to validate_presence_of :email }
    it { is_expected.to validate_presence_of :country }
    it { is_expected.to validate_presence_of :region }
    it { is_expected.to validate_presence_of :city }
  end

  context 'when associating models' do
    it { is_expected.to belong_to :hotel }
  end
end
