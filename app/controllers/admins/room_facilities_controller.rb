# frozen_string_literal: true

module Admins
  # Controller for Room Facilities
  class RoomFacilitiesController < AdminsController
    before_action :room
    before_action :room_facility, only: :destroy

    def create
      @room_facility = @room.room_facilities.build(room_facility_params)
      if @room_facility.save
        flash.now[:notice] = I18n.t('room_facility.create.success')
      else
        flash.now[:alert] = I18n.t('room_facility.create.error')
      end
      redirect_to admins_room_path(@room)
    end

    def destroy
      @room_facility.destroy
      flash[:notice] = I18n.t('room_facility.destroy.success')
      redirect_to admins_room_path(@room)
    end

    private

    def room
      @room ||= Room.find(params[:room_id])
    end

    def room_facility
      @room_facility ||= RoomFacility.find(params[:id])
    end

    def room_facility_params
      params.require(:room_facility).permit(:facility_id)
    end
  end
end
