# frozen_string_literal: true

module Admins
  # Manages amenities for hotels in the admins interface
  class AmenitiesController < AdminsController
    include ImageAttachment
    before_action :amenity, only: %i[edit update destroy]

    def index
      amenity_query = AmenityQuery.new(@hotel, params)
      @pagy, @amenities = pagy(amenity_query.call, items: 10)
    end

    def new
      @amenity = @hotel.amenities.new
    end

    def edit; end

    def create
      @amenity = @hotel.amenities.new(amenity_params)
      if @amenity.save
        flash[:notice] = I18n.t('amenity.create.success')
        redirect_to admins_amenities_path
      else
        flash[:alert] = I18n.t('amenity.create.error')
        render :new, status: :unprocessable_content
      end
    end

    def update
      if @amenity.update(amenity_params.except(:image))
        self.class.attach_image(@amenity, amenity_params, :image)
        flash[:notice] = I18n.t('amenity.update.success')
        redirect_to admins_amenities_path
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

    def amenity
      @amenity ||= Amenity.find(params[:id])
    end

    def amenity_params
      params.require(:amenity).permit(:name, :image)
    end

    def destroy_response
      respond_to do |format|
        format.html { redirect_to admins_amenities_path }
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
