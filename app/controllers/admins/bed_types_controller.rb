# frozen_string_literal: true

module Admins
  # Controller for Room Bed Type
  class BedTypesController < AdminsController
    before_action :hotel
    before_action :bed_type, only: %i[edit update destroy]

    def new
      @bed_type = @hotel.bed_types.new
    end

    def edit; end

    def create
      @bed_type = @hotel.bed_types.new(bed_type_params)
      if @bed_type.save
        flash[:notice] = I18n.t('bed_type.create.success')
        redirect_to admins_hotel_room_categories_path(@hotel)
      else
        flash[:alert] = I18n.t('bed_type.create.error')
        render :new, status: :unprocessable_entity
      end
    end

    def update
      if @bed_type.update(bed_type_params)
        flash[:notice] = I18n.t('bed_type.update.success')
        redirect_to admins_hotel_room_categories_path(@hotel)
      else
        flash[:alert] = I18n.t('bed_type.update.success')
        render :edit, status: :unprocessable_entity
      end
    end

    def destroy
      @bed_type.destroy
      flash[:notice] = I18n.t('bed_type.destroy.success')
      redirect_to admins_hotel_room_categories_path(@hotel)
    end

    private

    def hotel
      @hotel ||= Hotel.find(params[:hotel_id])
    end

    def bed_type
      @bed_type ||= BedType.find(params[:id])
    rescue ActiveRecord::RecordNotFound
      flash.now[:alert] = I18n.t('bed_type.not_found')
      redirect_to admins_hotel_room_categories_path(@hotel)
    end

    def bed_type_params
      params.require(:bed_type).permit(:name)
    end
  end
end
