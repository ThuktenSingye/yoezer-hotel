require 'rails_helper'

RSpec.describe Admin, type: :model do
  context 'associations' do
    it { should have_one :profile }
  end
end
