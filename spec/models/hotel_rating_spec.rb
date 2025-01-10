require 'rails_helper'

RSpec.describe HotelRating, type: :model do
  context "associations" do
    it { should belong_to :hotel }
  end
end
