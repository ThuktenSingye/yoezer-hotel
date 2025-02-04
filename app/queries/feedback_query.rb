# frozen_string_literal: true

# Feedback Query Class for searching and filtering feedback
class FeedbackQuery < BaseQuery
  def call
    feedbacks = @hotel.feedbacks
    feedbacks = search_feedback(feedbacks) if @params[:query].present?

    ordered_records(feedbacks)
  end

  private

  def search_feedback(feedbacks)
    feedbacks.where('name LIKE :search OR email LIKE :search', search: "%#{@params[:query]}%")
  end
end
