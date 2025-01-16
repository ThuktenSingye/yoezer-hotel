require 'rails_helper'

RSpec.describe Address, type: :model do
  context "validations" do
    it { should validate_presence_of :dzongkhag }
    it { should validate_presence_of :gewog }
    it { should validate_presence_of :street_address }
    it { should define_enum_for(:address_type).with_values([ :present, :permanent ]) }
  end
end
