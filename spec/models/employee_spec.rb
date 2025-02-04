# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Employee, type: :model do
  context 'when validating attributes' do
    it { is_expected.to validate_presence_of :email }
  end

  context 'when associating models' do
    it { is_expected.to have_many_attached :documents }
    it { is_expected.to have_one :profile }
  end
end
