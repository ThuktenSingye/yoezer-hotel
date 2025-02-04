# frozen_string_literal: true

module Admins
  # Manages offers for hotels in the admins interface
  class OffersController < AdminsController
    include ImageAttachment
    before_action :hotel
    before_action :offer, only: %i[show edit update destroy]

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
        redirect_to admins_hotel_offers_path(@hotel)
      else
        flash[:alert] = I18n.t('offer.create.error')
        render :new, status: :unprocessable_entity
      end
    end

    def update
      if @offer.update(offer_params.except(:image))
        self.class.attach_image(@offer, offer_params, :image)
        flash[:notice] = I18n.t('offer.update.success')
        redirect_to admins_hotel_offer_path(@hotel, @offer)
      else
        flash[:alert] = I18n.t('offer.update.error')
        render :edit, status: :unprocessable_entity
      end
    end

    def destroy
      @offer.destroy
      flash[:notice] = I18n.t('offer.destroy.success')
      redirect_to admins_hotel_offer_path(@hotel, @offer)
    end

    private

    def hotel
      @hotel ||= Hotel.find(params[:hotel_id])
    end

    def offer
      @offer ||= Offer.find(params[:id])
    rescue ActiveRecord::RecordNotFound
      flash.now[:alert] = I18n.t('offer.not_found')
      redirect_to admins_hotel_offers_path(@hotel)
    end

    def offer_params
      params.require(:offer).permit(:title, :description, :start_time, :end_time, :discount, :image)
    end
  end
end
