require 'rails_helper'

RSpec.describe HotelGallery, type: :model do
  context "validation" do
    it { should validate_presence_of :name }
    it { should validate_presence_of :description }
  end

  context 'associations' do
    it { should belong_to :hotel }
    it { should have_many_attached :images }
  end
end
