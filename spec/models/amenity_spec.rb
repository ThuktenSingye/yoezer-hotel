require 'rails_helper'

RSpec.describe Amenity, type: :model do
  context "validations" do
    it { should validate_presence_of :name }
  end
  context "associations" do
    it { should have_one_attached :image }
  end
end
