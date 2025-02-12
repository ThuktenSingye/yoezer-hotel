# frozen_string_literal: true

# User Feedback Controller
class FeedbacksController < HomeController

  def index
    @hotel = Hotel.find(params[:hotel_id])
    @booking = @hotel.bookings.find_by(id: params[:booking_id],feedback_token: params[:token])
    if @booking && validate_feedback_link(@booking)
      @room = @booking.room
    else
      flash[:alert] = "Token Expired or Invalid. Cannot Provide Feedback."
      redirect_to home_path
    end
  end

  def create
    @guest = @hotel.guests.find_by(email: feedback_params[:email])
    @feedback = @hotel.feedbacks.new(feedback_params)
    if @guest && @feedback.save
      flash[:notice] = I18n.t('feedback.create.success')
    else
      flash[:alert] = I18n.t('feedback.create.error')
    end

    redirect_to contact_path
  end

  private

  def validate_feedback_link(booking)
    booking.feedback_expires_at > Time.current
  end

  def feedback_params
    params.require(:feedback).permit(:name, :email, :feedback)
  end
end
