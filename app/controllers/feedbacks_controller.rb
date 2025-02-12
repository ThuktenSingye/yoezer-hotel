# frozen_string_literal: true

# User Feedback Controller
class FeedbacksController < HomeController
  def create
    @feedback = @hotel.feedbacks.new(feedback_params)
    if @feedback.save
      flash[:notice] = I18n.t('feedback.create.success')
    else
      flash[:alert] = I18n.t('feedback.create.error')
    end
    redirect_to contact_path
  end

  private

  def feedback_params
    params.require(:feedback).permit(:name, :email, :feedback)
  end
end
