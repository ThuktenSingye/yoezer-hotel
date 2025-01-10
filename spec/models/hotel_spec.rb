require 'rails_helper'

RSpec.describe Hotel, type: :model do
  context "validations" do
    it { should validate_presence_of :name }
    it { should validate_presence_of :email }
    it { should validate_presence_of :contact_no }
    it { should have_one :address }
  end
end
