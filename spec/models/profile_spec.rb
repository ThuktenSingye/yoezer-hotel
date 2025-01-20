require 'rails_helper'

RSpec.describe Profile, type: :model do
  let(:admin) { FactoryBot.create(:admin) }
  let(:profile) { FactoryBot.create(:profile,  profileable: admin) }

  context "validations" do
    it { should validate_presence_of(:first_name) }
    it { should validate_presence_of(:cid_no) }
    it { should validate_presence_of(:contact_no) }
  end

  context "associations" do
    it { should have_many :addresses }
    it { should have_one_attached :avatar }
  end
end
