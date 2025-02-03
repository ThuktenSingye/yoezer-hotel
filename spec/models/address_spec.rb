# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Address, type: :model do
  context 'when validating attributes' do
    it { is_expected.to validate_presence_of :dzongkhag }
    it { is_expected.to validate_presence_of :gewog }
    it { is_expected.to validate_presence_of :street_address }
    it { is_expected.to define_enum_for(:address_type).with_values(%i[present permanent]) }
  end
end
