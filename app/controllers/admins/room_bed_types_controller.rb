# frozen_string_literal: true

module Admins
  # Controller for Room Bed Type junction model
  class RoomBedTypesController < AdminsController
    before_action :room
    before_action :room_bed_type, only: :destroy

    def new
      @room_bed_type = @room.room_bed_types.new
    end

    def create
      @room_bed_type = @room.room_bed_types.build(room_bed_type_params)
      if @room_bed_type.save
        flash.now[:notice] = I18n.t('room_bed_type.create.success')
      else
        flash.now[:alert] = I18n.t('room_bed_type.create.error')
      end
      redirect_to admins_room_path(@room)
    end

    def destroy
      @room_bed_type.destroy
      flash[:notice] = I18n.t('room_bed_type.destroy.success')
      redirect_to admins_room_path(@room)
    end

    private

    def room
      @room ||= Room.find(params[:room_id])
    end

    def room_bed_type
      @room_bed_type ||= RoomBedType.find(params[:id])
    end

    def room_bed_type_params
      params.require(:room_bed_type).permit(:bed_type_id, :num_of_bed)
    end
  end
end
