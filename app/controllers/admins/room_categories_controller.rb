# frozen_string_literal: true

module Admins
  # Controller for managing room categories within the admin hotel interface.
  class RoomCategoriesController < AdminsController
    before_action :hotel
    before_action :room_category, only: %i[edit update destroy]

    def index
      @pagy, @room_categories = pagy(@hotel.room_categories.order(created_at: :desc), limit: 5)
    end

    def new
      @room_category = @hotel.room_categories.new
    end

    def edit; end

    def create
      @room_category = @hotel.room_categories.new(room_category_params)
      if @room_category.save
        flash[:notice] = I18n.t('room_category.create.success')
        redirect_to admins_hotel_room_categories_path(@hotel)
      else
        flash[:alert] = I18n.t('room_category.create.error')
        render :new, status: :unprocessable_entity
      end
    end

    def update
      if @room_category.update(room_category_params)
        flash[:notice] = I18n.t('room_category.update.success')
        redirect_to admins_hotel_room_categories_path(@hotel)
      else
        flash[:alert] = I18n.t('room_category.update.success')
        render :edit, status: :unprocessable_entity
      end
    end

    def destroy
      @room_category.destroy
      destroy_response
    end

    private

    def hotel
      @hotel ||= Hotel.find(params[:hotel_id])
    end

    def room_category
      @room_category ||= RoomCategory.find(params[:id])
    rescue ActiveRecord::RecordNotFound
      flash.now[:alert] = I18n.t('room_category.not_found')
      redirect_to admins_hotel_room_categories_path(@hotel)
    end

    def room_category_params
      params.require(:room_category).permit(:name)
    end

    def destroy_response
      respond_to do |format|
        format.html { redirect_to admins_hotel_room_categories_path(@hotel) }
        format.turbo_stream do
          flash.now[:notice] = I18n.t('room_category.destroy.success')
          render turbo_stream: [
            turbo_stream.remove(@room_category),
            turbo_stream.prepend('flash', partial: 'shared/flash')
          ]
        end
      end
    end
  end
end
