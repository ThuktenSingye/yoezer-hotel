require 'rails_helper'

RSpec.describe Offer, type: :model do
  context "validations" do
    it { should validate_presence_of :title }
    it { should validate_presence_of :description }
    it { should validate_presence_of :start_time }
    it { should validate_presence_of :end_time }
    it { should validate_numericality_of(:discount).is_in(0..100) }
  end

  context "associations" do
    it { should belong_to :hotel }
    it { should have_one_attached :image }
  end
end
