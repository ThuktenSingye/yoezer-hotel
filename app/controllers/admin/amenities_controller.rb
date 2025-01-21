# frozen_string_literal: true

module Admin
  # Manages amenities for hotels in the admin interface
  class AmenitiesController < AdminController
    before_action :set_amenity, only: %i[edit update destroy]
    before_action :set_hotel

    def index
      if params[:query].present?
        @pagy, @amenities = pagy(@hotel.amenities.where('name LIKE ?', "%#{params[:query]}%").order(created_at: :desc))
      else
        @pagy, @amenities = pagy(@hotel.amenities.order(created_at: :desc), items: 5)
      end
    end

    def new
      @amenity = @hotel.amenities.new
    end

    def edit; end

    def create
      @amenity = @hotel.amenities.new(amenity_params)
      if @amenity.save
        flash[:notice] = I18n.t('amenity.create.success')
        redirect_to admin_hotel_amenities_path(@hotel)
      else
        flash[:alert] = I18n.t('amenity.create.error')
        render :new, status: :unprocessable_content
      end
    end

    def update
      if @amenity.update(amenity_params.except(:image))
        attach_image(@amenity)
        flash[:notice] = I18n.t('amenity.update.success')
        redirect_to admin_hotel_amenities_path(@hotel)
      else
        flash[:alert] = I18n.t('amenity.update.error')
        render :edit, status: :unprocessable_content
      end
    end

    def destroy
      @amenity.destroy
      destroy_response
    end

    private

    def set_hotel
      @set_hotel ||= Hotel.find(params[:hotel_id])
    end

    def set_amenity
      @hotel ||= Hotel.find(params[:hotel_id])
      @set_amenity ||= @hotel.amenities&.find(params[:id])
    end

    def amenity_params
      params.require(:amenity).permit(:name, :image)
    end

    def attach_image(amenity)
      return unless valid_image?(amenity_params[:image])

      amenity.image.attach(amenity_params[:image])
    end

    def valid_image?(image)
      image.present? && image.is_a?(ActionDispatch::Http::UploadedFile)
    end

    def destroy_response
      respond_to do |format|
        format.html { redirect_to admin_hotel_amenities_path(@hotel) }
        format.turbo_stream do
          flash.now[:notice] = I18n.t('amenity.destroy.success')
          render turbo_stream: [
            turbo_stream.remove(@amenity),
            turbo_stream.prepend('flash', partial: 'shared/flash')
          ]
        end
      end
    end
  end
end
