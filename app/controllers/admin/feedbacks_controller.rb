# frozen_string_literal: true

module Admin
  # Manages feedback for hotels in the admin interface
  class FeedbacksController < AdminController
    before_action :set_feedback, only: [:destroy]
    before_action :set_hotel

    def index
      if params[:query].present?
        @search = params[:query]
        @pagy, @feedbacks = pagy(@hotel.feedbacks.where('name LIKE :search OR email LIKE :search',
                                                        search: "%#{@search}%").order(created_at: :desc))
      else
        @pagy, @feedbacks = pagy(@hotel.feedbacks.order(created_at: :desc))
      end
    end

    def destroy
      @feedback.destroy
      destroy_response
    end

    private

    def set_hotel
      @set_hotel ||= Hotel.find(params[:hotel_id])
    end

    def set_feedback
      @hotel ||= Hotel.find(params[:hotel_id])
      @set_feedback ||= @hotel.feedbacks&.find(params[:id])
    end

    def feedback_params
      params.require(:feedback).permit(:name, :email, :feedback)
    end

    def destroy_response
      respond_to do |format|
        format.html { redirect_to admin_hotel_feedbacks_path(@hotel) }
        format.turbo_stream do
          flash[:notice] = I18n.t('feedback.destroy.success')
          render turbo_stream: [
            turbo_stream.remove(@feedback),
            turbo_stream.prepend('flash', partial: 'shared/flash')
          ]
        end
      end
    end
  end
end
