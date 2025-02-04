# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Hotel, type: :model do
  context 'when validating attributes' do
    it { is_expected.to validate_presence_of :name }
    it { is_expected.to validate_presence_of :email }
    it { is_expected.to validate_presence_of :contact_no }
  end

  context 'when associating models' do
    it { is_expected.to have_many :address }
    it { is_expected.to have_many :hotel_ratings }
    it { is_expected.to have_many :amenities }
    it { is_expected.to have_many :feedbacks }
    it { is_expected.to have_many :hotel_galleries }
    it { is_expected.to have_many :offers }
    it { is_expected.to have_many :room_categories }
    it { is_expected.to have_many :bed_types }
    it { is_expected.to have_many :employees }
  end
end
