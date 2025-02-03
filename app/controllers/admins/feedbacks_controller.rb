# frozen_string_literal: true

module Admins
  # Manages feedback for hotels in the admins interface
  class FeedbacksController < AdminsController
    before_action :feedback, only: [:destroy]
    before_action :hotel

    def index
      feedback_query = FeedbackQuery.new(@hotel, params)
      @pagy, @feedbacks = pagy(feedback_query.call, items: 10)
    end

    def destroy
      @feedback.destroy
      destroy_response
    end

    private

    def hotel
      @hotel ||= Hotel.find(params[:hotel_id])
    end

    def feedback
      @feedback ||= Feedback.find(params[:id])
    end

    def feedback_params
      params.require(:feedback).permit(:name, :email, :feedback)
    end

    def destroy_response
      respond_to do |format|
        format.html { redirect_to admins_hotel_feedbacks_path(@hotel) }
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
