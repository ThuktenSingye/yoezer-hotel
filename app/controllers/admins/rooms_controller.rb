# frozen_string_literal: true

module Admins
  # Room Controller
  class RoomsController < AdminsController
    include ImageAttachment
    before_action :hotel
    before_action :room, only: %i[show edit update destroy]

    def index
      # @rooms = @hotel.rooms.includes(:room_ratings).order(created_at: :desc)
      room_query = RoomQuery.new(@hotel, params)
      @rooms = room_query.call
    end

    def show; end

    def new
      @room = @hotel.rooms.new
    end

    def edit; end

    def create
      @room = @hotel.rooms.build(room_params)
      if @room.save
        flash[:notice] = I18n.t('room.create.success')
        redirect_to admins_hotel_rooms_path(@hotel)
      else
        flash[:alert] = I18n.t('room.create.error')
        render :new, status: :unprocessable_entity
      end
    end

    def update
      destroy_all_image
      if @room.update(room_params)
        flash[:notice] = I18n.t('room.update.success')
        redirect_to admins_hotel_room_path(@hotel, @room)
      else
        flash[:alert] = I18n.t('room.update.error')
        render :edit, status: :unprocessable_entity
      end
    end

    def destroy
      @room.destroy
      flash[:notice] = I18n.t('room.destroy.success')
      redirect_to admins_hotel_rooms_path(@hotel)
    end

    private

    def hotel
      @hotel ||= Hotel.find(params[:hotel_id])
    end

    def room
      @room ||= @hotel.rooms.find(params[:id])
    rescue ActiveRecord::RecordNotFound
      flash.now[:alert] = I18n.t('room.not_found')
      redirect_to admins_hotel_rooms_path(@hotel)
    end

    def destroy_all_image
      @room.images.destroy_all
    end

    def room_params
      params.require(:room).permit(
        :room_number, :floor_number,
        :base_price,
        :description,
        :max_no_adult,
        :max_no_children,
        :status,
        :room_category_id,
        :image, images: []
      )
    end
  end
end
