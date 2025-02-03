# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Admin, type: :model do
  context 'when associating models' do
    it { is_expected.to have_one :profile }
  end
end
