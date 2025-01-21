# frozen_string_literal: true

module Admin
  # Manages offers for hotels in the admin interface
  class OffersController < AdminController
    before_action :set_hotel
    before_action :set_offer, only: %i[show edit update destroy]
    def index
      @offers = @hotel.offers.order(created_at: :desc)
    end

    def show; end

    def new
      @offer = @hotel.offers.new
    end

    def edit; end

    def create
      @offer = @hotel.offers.new(offer_params)
      if @offer.save
        flash[:notice] = I18n.t('offer.create.success')
        redirect_to admin_hotel_offers_path(@hotel)
      else
        flash[:alert] = I18n.t('offer.create.error')
        render :new, status: :unprocessable_entity
      end
    end

    def update
      if @offer.update(offer_params.except(:image))
        attach_image(@offer)
        flash[:notice] = I18n.t('offer.update.success')
        redirect_to admin_hotel_offer_path(@hotel, @offer)
      else
        flash[:alert] = I18n.t('offer.update.error')
        render :edit, status: :unprocessable_entity
      end
    end

    def destroy
      @offer.destroy
      flash[:notice] = I18n.t('offer.destroy.success')
      redirect_to admin_hotel_offer_path(@hotel, @offer)
    end

    private

    def set_hotel
      @set_hotel ||= Hotel.find(params[:hotel_id])
    end

    def set_offer
      @hotel ||= Hotel.find(params[:hotel_id])
      @offer ||= @hotel.offers&.find(params[:id])
    rescue ActiveRecord::RecordNotFound
      flash.now[:alert] = I18n.t('offer.not_found')
      redirect_to admin_hotel_offers_path(@hotel)
    end

    def offer_params
      params.require(:offer).permit(:title, :description, :start_time, :end_time, :discount, :image)
    end

    def attach_image(offer)
      return unless valid_image?(offer_params[:image])

      offer.image.attach(offer_params[:image])
    end

    def valid_image?(image)
      image.present? && image.is_a?(ActionDispatch::Http::UploadedFile)
    end
  end
end
