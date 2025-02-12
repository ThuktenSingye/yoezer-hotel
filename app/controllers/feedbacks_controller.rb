# frozen_string_literal: true

class FeedbacksController < HomeController
  def create
    @feedback = @hotel.feedbacks.new(feedback_params)
    if @feedback.save
      flash[:notice] = 'Thank you for your feedback.'
    else
      flash[:alert] = 'Something went wrong. Please try again.'
    end
    redirect_to contact_path
  end

  private

  def feedback_params
    params.require(:feedback).permit(:name, :email, :feedback)
  end
end
