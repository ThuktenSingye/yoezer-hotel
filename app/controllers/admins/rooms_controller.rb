# frozen_string_literal: true

module Admins
  # Room Controller
  class RoomsController < AdminsController
    include ImageAttachment
    before_action :hotel
    before_action :room, only: %i[show edit update destroy]

    def index
      @rooms = @hotel.rooms.order(created_at: :desc)
    end

    def show; end

    def new
      @room = @hotel.rooms.new
    end

    def edit; end

    def create
      @room = @hotel.rooms.new(room_params.except('room_category_id'))
      @room.room_category = RoomCategory.find(room_params[:room_category_id]) if room_params[:room_category_id].present?
      if @room.save
        flash[:notice] = I18n.t('room.create.success')
        redirect_to admins_hotel_rooms_path(@hotel)
      else
        flash[:alert] = I18n.t('room.create.error')
        render :new, status: :unprocessable_entity
      end
    end

    def update
      @room.room_category = RoomCategory.find(room_params[:room_category_id]) if room_params[:room_category_id].present?
      if @room.update(room_params)
        self.class.attach_multiple_images(@room, room_params, :images)
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
      @room ||= Room.find(params[:id])
    rescue ActiveRecord::RecordNotFound
      flash.now[:alert] = I18n.t('room.not_found')
      redirect_to admins_hotel_rooms_path(@hotel)
    end

    def room_params
      params.require(:room).permit(:room_number, :floor_number, :status, :description, :base_price, :max_no_adult,
                                   :max_no_children, :room_category_id, images: [])
    end
  end
end
