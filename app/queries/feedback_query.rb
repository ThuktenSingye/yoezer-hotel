# frozen_string_literal: true

# Feedback query
class FeedbackQuery
  def initialize(hotel, params)
    @hotel = hotel
    @params = params
  end

  def call
    if @params[:query].present?
      search_feedback
    else
      all_feedback
    end
  end

  private

  def search_feedback
    @hotel.feedbacks.where('content LIKE ?', "%#{@params[:query]}%").order(created_at: :desc)
  end

  def all_feedback
    @hotel.feedbacks.order(created_at: :desc)
  end
end
