# frozen_string_literal: true

module Admins
  # Manages galleries for hotels in the admins interface
  class HotelGalleriesController < AdminsController
    include ImageAttachment
    before_action :hotel
    before_action :hotel_gallery, only: %i[show edit update destroy]

    def index
      @hotel_galleries = @hotel.hotel_galleries.order(created_at: :desc)
    end

    def show; end

    def new
      @hotel_gallery = @hotel.hotel_galleries.new
    end

    def edit; end

    def create
      @hotel_gallery = @hotel.hotel_galleries.new(hotel_gallery_params)
      if @hotel_gallery.save
        flash[:notice] = I18n.t('gallery.create.success')
        redirect_to admins_hotel_hotel_galleries_path(@hotel)
      else
        flash[:alert] = I18n.t('gallery.create.error')
        render :new, status: :unprocessable_entity
      end
    end

    def update
      if @hotel_gallery.update(hotel_gallery_params.except(:image))
        self.class.attach_image(@hotel_gallery, hotel_gallery_params, :image)
        flash[:notice] = I18n.t('gallery.update.success')
        redirect_to admins_hotel_hotel_galleries_path(@hotel)
      else
        flash[:alert] = I18n.t('gallery.update.error')
        render :edit, status: :unprocessable_entity
      end
    end

    def destroy
      @hotel_gallery.destroy
      flash[:notice] = I18n.t('gallery.destroy.success')
      redirect_to admins_hotel_hotel_galleries_path(@hotel)
    end

    private

    def hotel
      @hotel ||= Hotel.find(params[:hotel_id])
    end

    def hotel_gallery
      @hotel_gallery = HotelGallery.find(params[:id])
    rescue ActiveRecord::RecordNotFound
      flash.now[:alert] = I18n.t('gallery.not_found')
      redirect_to admins_hotel_hotel_galleries_path(@hotel)
    end

    def hotel_gallery_params
      params.require(:hotel_gallery).permit(:name, :description, :image)
    end
  end
end
