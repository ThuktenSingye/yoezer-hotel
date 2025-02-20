# frozen_string_literal: true

module Admins
  # Manages hotels in the admins interface
  class HotelsController < AdminsController
    include RatingCalculator

    def show; end

    def edit; end

    def update
      destroy_all_image
      if @hotel.update(hotel_params)
        flash[:notice] = I18n.t('hotel.update.success')
        render :show, status: :found
      else
        flash[:alert] = I18n.t('hotel.update.error')
        render :show, status: :unprocessable_content
      end
    end

    private

    def destroy_all_image
      @hotel.images.destroy_all
    end

    def hotel_params
      params.require(:hotel).permit(:name, :email, :contact_no, :description,
                                    address_attributes: %i[id dzongkhag gewog street_address],
                                    images: [])
    end
  end
end
