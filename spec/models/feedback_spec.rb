require 'rails_helper'

RSpec.describe Feedback, type: :model do
  context "associations" do
    it { should belong_to :hotel }
  end
end
