# frozen_string_literal: true

module Admins
  # Room Controller
  class RoomsController < AdminsController
    include ImageAttachment
    before_action :room, only: %i[show edit update destroy]
    before_action :offers, only: %i[index show]

    def index
      room_query = RoomQuery.new(@hotel, params)
      @pagy, @rooms = pagy(room_query.call, limit: 6)
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
        redirect_to admins_rooms_path
      else
        flash[:alert] = I18n.t('room.create.error')
        render :new, status: :unprocessable_entity
      end
    end

    def update
      destroy_all_image
      if @room.update(room_params)
        flash[:notice] = I18n.t('room.update.success')
        redirect_to admins_room_path(@room)
      else
        flash[:alert] = I18n.t('room.update.error')
        render :edit, status: :unprocessable_entity
      end
    end

    def destroy
      @room.destroy
      flash[:notice] = I18n.t('room.destroy.success')
      redirect_to admins_rooms_path
    end

    private

    def room
      @room ||= @hotel.rooms.find(params[:id])
    rescue ActiveRecord::RecordNotFound
      flash.now[:alert] = I18n.t('room.not_found')
      redirect_to  admins_rooms_path
    end

    def offers
      @offers = OfferQuery.new(@hotel).call
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
        :room_category_id, :image, images: []
      )
    end
  end
end
