class Admin::FeedbacksController < AdminController
  before_action :set_feedback, only: [ :destroy ]
  before_action :set_hotel

  def index
    if params[:query].present?
      @search = params[:query]
      @pagy, @feedbacks = pagy(@hotel.feedbacks.where("name LIKE :search OR email LIKE :search", search: "%#{@search}%").order(created_at: :desc))
    else
      @pagy, @feedbacks = pagy(@hotel.feedbacks.order(created_at: :desc))
    end
  end

  def destroy
    @feedback.destroy
    respond_to do |format|
      format.html { redirect_to admin_hotel_feedbacks_path(@hotel) }
      format.turbo_stream do
        flash[:notice] = "Feedback was successfully deleted!"
        render turbo_stream: [
          turbo_stream.remove(@feedback),
          turbo_stream.prepend("flash", partial: "shared/flash")
        ]
      end
    end
  end

  private

  def set_hotel
    @hotel ||= Hotel.find(params[:hotel_id])
  end

  def set_feedback
    @hotel ||= Hotel.find(params[:hotel_id])
    @feedback ||= @hotel.feedbacks&.find(params[:id])
  end

  def feedback_params
    params.require(:feedback).permit(:name, :email, :feedback)
  end
end
