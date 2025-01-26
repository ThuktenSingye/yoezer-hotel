# frozen_string_literal: true

# Method to calculate rating star
module RatingCalculable
  extend ActiveSupport::Concern

  class_methods do
    def calculate_rating(record_rating)
      full_stars = record_rating.to_i
      half_stars = record_rating - full_stars >= 0.5 ? 1 : 0
      empty_stars = 5 - full_stars - half_stars

      {
        full_stars: full_stars,
        half_stars: half_stars,
        empty_stars: empty_stars
      }
    end
  end
end
