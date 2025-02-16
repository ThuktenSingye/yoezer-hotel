# frozen_string_literal: true

# User Feedback Controller
class FeedbacksController < HomeController
  def index
    @feedback = @hotel.feedbacks.new
    @booking = @hotel.bookings.find_by(id: params[:booking_id], feedback_token: params[:token])
    if @booking && validate_feedback_link(@booking)
      set_room_and_guest
    else
      flash[:alert] = I18n.t('feedback.token_expired')
      redirect_to home_path
    end
  end

  def create
    @guest = @hotel.guests.find_by(email: feedback_params[:email])

    if feedback_already_exists?
      flash[:alert] = I18n.t('feedback.already_given')
    else
      save_feedback
    end

    redirect_to request.referer
  end

  private

  def feedback_already_exists?
    @hotel.feedbacks.exists?(email: feedback_params[:email])
  end

  def save_feedback
    @feedback = @hotel.feedbacks.new(feedback_params)

    if @guest && @feedback.save
      flash[:notice] = I18n.t('feedback.create.success')
    else
      flash[:alert] = I18n.t('feedback.create.error')
    end
  end

  def validate_feedback_link(booking)
    booking.feedback_expires_at > Time.current
  end

  def set_room_and_guest
    @room = @booking.room
    @guest = @booking.guest
  end

  def feedback_params
    params.require(:feedback).permit(:name, :email, :feedback)
  end
end
