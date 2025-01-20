require 'rails_helper'

RSpec.describe Hotel, type: :model do
  context "validations" do
    it { should validate_presence_of :name }
    it { should validate_presence_of :email }
    it { should validate_presence_of :contact_no }
  end

  context "associations" do
    it { should have_many :address }
    it { should have_many :hotel_ratings }
    it { should have_many :amenities }
    it { should have_many :feedbacks }
    it { should have_many :hotel_galleries}
  end
end
