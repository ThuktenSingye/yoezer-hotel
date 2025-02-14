# frozen_string_literal: true

module Admins
  # Manages hotels in the admins interface
  class HotelsController < AdminsController
    include RatingCalculator
    before_action :hotel, only: %i[edit update]

    def index
      @hotel = Hotel.includes(:address, :hotel_ratings).first
    end

    def edit; end

    def update
      if @hotel.update(hotel_params)
        success_response
      else
        flash[:alert] = I18n.t('hotel.update.error')
        render :index, status: :unprocessable_content
      end
    end

    private

    def hotel
      @hotel ||= Hotel.find(params[:id])
    end

    def hotel_params
      params.require(:hotel).permit(:name, :email, :contact_no, :description,
                                    address_attributes: %i[id dzongkhag gewog street_address])
    end

    def success_response
      respond_to do |format|
        format.html { redirect_to admins_hotels_path }
        format.turbo_stream do
          flash.now[:notice] = I18n.t('hotel.update.success')
          render turbo_stream: [
            turbo_stream.replace(@hotel, partial: 'admins/hotels/hotel', locals: { hotel: @hotel }),
            turbo_stream.prepend('flash', partial: 'shared/flash')
          ]
        end
      end
    end

    def failure_response
      respond_to do |format|
        format.html { render :index, status: :unprocessable_content }
        format.turbo_stream do
          flash.now[:alert] = I18n.t('hotel.update.error')
          render turbo_stream: [
            turbo_stream.replace(@hotel, partial: 'admins/hotels/form', locals: { hotel: @hotel }),
            turbo_stream.prepend('flash', partial: 'shared/flash')
          ]
        end
      end
    end
  end
end
