# frozen_string_literal: true

module Admins
  # Manages hotels in the admins interface
  class HotelsController < AdminsController
    before_action :hotel, only: %i[edit update]
    before_action :set_rating, only: %i[index update]

    def index
      @hotel = Hotel.includes(:address).first
    end

    def edit; end

    def update
      if @hotel.update(hotel_params)
        success_response
      else
        failure_response
      end
    end

    private

    def hotel
      @hotel ||= Hotel.find(params[:id])
    end

    def set_rating
      @hotel_ratings = Hotel.includes(:hotel_ratings).average(:rating) || 0
      @rating = {
        full_stars: @hotel_ratings.to_i,
        half_stars: @hotel_ratings - @hotel_ratings.to_i >= 0.5,
        empty_stars: 5 - @hotel_ratings.to_i - (@hotel_ratings - @hotel_ratings.to_i ? 1 : 0)
      }
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
