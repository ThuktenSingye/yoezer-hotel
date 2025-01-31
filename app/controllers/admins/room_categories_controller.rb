# frozen_string_literal: true

module Admins
  # Controller for managing room categories within the admin hotel interface.
  class RoomCategoriesController < AdminsController
    before_action :hotel
    before_action :room_category, only: %i[edit update destroy]

    def index
      @room_categories_pagy, @room_categories = pagy(
        @hotel.room_categories.order(created_at: :desc),
        limit: 5,
        page_param: :room_categories_page
      )

      @bed_types_pagy, @bed_types = pagy(
        @hotel.bed_types.order(created_at: :desc),
        limit: 5,
        page_param: :bed_types_page
      )
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
      flash[:notice] = I18n.t('room_category.destroy.success')
      redirect_to admins_hotel_room_categories_path(@hotel)
    end

    private

    def hotel
      @hotel ||= Hotel.find(params[:hotel_id])
    end

    def room_category
      @room_category ||= @hotel.room_categories.find(params[:id])
    rescue ActiveRecord::RecordNotFound
      flash.now[:alert] = I18n.t('room_category.not_found')
      redirect_to admins_hotel_room_categories_path(@hotel)
    end

    def room_category_params
      params.require(:room_category).permit(:name)
    end
  end
end
