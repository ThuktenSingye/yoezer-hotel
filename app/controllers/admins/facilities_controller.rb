# frozen_string_literal: true

module Admins
  # Room Facility Controller
  class FacilitiesController < AdminsController
    include ImageAttachment
    before_action :hotel
    before_action :facility, only: %i[edit update destroy]

    def index
      facility_query = FacilityQuery.new(@hotel, params)
      @pagy, @facilities = pagy(facility_query.call, items: 10)
    end

    def new
      @facility = @hotel.facilities.new
    end

    def edit; end

    def create
      @facility = @hotel.facilities.new(facility_params)
      if @facility.save
        flash[:notice] = I18n.t('facility.create.success')
        redirect_to admins_hotel_facilities_path(@hotel)
      else
        flash[:alert] = I18n.t('facility.create.error')
        render :new, status: :unprocessable_content
      end
    end

    def update
      if @facility.update(facility_params)
        # self.class.attach_image(@facility, amenity_params, :image)
        flash[:notice] = I18n.t('facility.update.success')
        redirect_to admins_hotel_facilities_path(@hotel)
      else
        flash[:alert] = I18n.t('amenity.update.error')
        render :edit, status: :unprocessable_content
      end
    end

    def destroy
      @facility.destroy
      flash[:notice] = I18n.t('facility.destroy.success')
      redirect_to admins_hotel_facilities_path(@hotel)
    end

    private

    def hotel
      @hotel ||= Hotel.find(params[:hotel_id])
    end

    def facility
      @facility ||= @hotel.facilities.find(params[:id])
    end

    def facility_params
      params.require(:facility).permit(:name, :image)
    end
  end
end
