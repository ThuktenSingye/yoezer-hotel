# frozen_string_literal: true

module Admin
  # Manages galleries for hotels in the admin interface
  class HotelGalleriesController < AdminController
    before_action :set_gallery, only: %i[show edit update destroy]
    before_action :set_hotel

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
        redirect_to admin_hotel_hotel_galleries_path(@hotel)
      else
        flash[:alert] = I18n.t('gallery.create.error')
        render :new, status: :unprocessable_entity
      end
    end

    def update
      if @hotel_gallery.update(hotel_gallery_params.except(:image))
        attach_image(@hotel_gallery)
        flash[:notice] = I18n.t('gallery.update.success')
        redirect_to admin_hotel_hotel_galleries_path(@hotel)
      else
        flash[:alert] = I18n.t('gallery.update.error')
        render :edit, status: :unprocessable_entity
      end
    end

    def destroy
      @hotel_gallery.destroy
      flash[:notice] = I18n.t('gallery.destroy.success')
      redirect_to admin_hotel_hotel_galleries_path(@hotel)
    end

    private

    def set_hotel
      @set_hotel ||= Hotel.find(params[:hotel_id])
    end

    def set_gallery
      @hotel ||= Hotel.find(params[:hotel_id])
      @hotel_gallery = @hotel&.hotel_galleries&.find(params[:id])
    rescue ActiveRecord::RecordNotFound
      flash.now[:alert] = I18n.t('gallery.not_found')
      redirect_to admin_hotel_hotel_galleries_path(@hotel)
    end

    def hotel_gallery_params
      params.require(:hotel_gallery).permit(:name, :description, :image)
    end

    def attach_image(gallery)
      return unless valid_image?(hotel_gallery_params[:image])

      gallery.image.attach(hotel_gallery_params[:image])
    end

    def valid_image?(image)
      image.present? && image.is_a?(ActionDispatch::Http::UploadedFile)
    end
  end
end
