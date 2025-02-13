# frozen_string_literal: true

module Admins
  # Guest Controller
  class GuestsController < AdminsController
    before_action :guest, only: %i[show edit update]

    def index
      @pagy, @guests = pagy(GuestQuery.new(@hotel, params).call, limit: 10)
    end

    def show; end

    def edit; end

    def update
      if @guest.update(guest_params)
        flash[:notice] = I18n.t('guest.update.success')
        redirect_to admins_guest_path(@guest)
      else
        flash[:alert] = I18n.t('guest.update.success')
        render :edit, status: :unprocessable_entity
      end
    end

    def destroy_all
      @hotel.guests.destroy_all
      flash[:notice] = I18n.t('guest.destroy_all')
      redirect_to admins_guests_path
    end

    private

    def guest
      @guest ||= @hotel.guests.find(params[:id])
    rescue ActiveRecord::RecordNotFound
      flash[:alert] = I18n.t('guest.not-found')
      redirect_to admins_guests_path
    end

    def guest_params
      params.require(:guest).permit(:first_name, :last_name, :email, :contact_no, :country, :region, :city)
    end
  end
end
