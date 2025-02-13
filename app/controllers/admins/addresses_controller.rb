# frozen_string_literal: true

module Admins
  # Manages addresses for hotels in the admins interface
  class AddressesController < AdminsController
    before_action :address, only: [:destroy]

    def new
      @address = Address.new
    end

    def create
      @address = @hotel.address.build(address_params)
      if @address.save
        success_response
      else
        failure_response
      end
    end

    def destroy
      @address.destroy
      destroy_response
    end

    private

    def address_params
      params.require(:address).permit(:dzongkhag, :gewog, :street_address)
    end

    def address
      @address ||= Address.find(params[:id])
    rescue ActiveRecord::RecordNotFound
      flash[:alert] = I18n.t('address.not_found')
      redirect_to admins_path
    end

    def success_response
      respond_to do |format|
        format.html { redirect_to admins_admin_root_path }
        format.turbo_stream do
          flash[:notice] = I18n.t('address.create.success')
          render turbo_stream: [
            turbo_stream.prepend('new_address', partial: 'admins/hotels/hotel', locals: { address: @address }),
            turbo_stream.prepend('flash', partial: 'shared/flash')
          ]
        end
      end
    end

    def failure_response
      respond_to do |format|
        format.html { redirect_to admins_admin_root_path, status: :unprocessable_entity }
        format.turbo_stream do
          flash.now[:alert] = I18n.t('address.create.error')
          render turbo_stream: [
            turbo_stream.prepend('flash', partial: 'shared/flash')
          ]
        end
      end
    end

    def destroy_response
      respond_to do |format|
        format.html { redirect_to admins_admin_root_path }
        format.turbo_stream do
          flash[:notice] = I18n.t('address.destroy.success')
          render turbo_stream: [
            turbo_stream.remove(@address),
            turbo_stream.prepend('flash', partial: 'shared/flash')
          ]
        end
      end
    end
  end
end
