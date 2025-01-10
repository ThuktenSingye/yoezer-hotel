class Admin::HotelsController < ApplicationController
  layout "admin"

  before_action :set_hotel, only: [ :edit, :update ]
  before_action :authenticate_admin!

  def index
    @hotel = Hotel.all
  end

  def edit; end

  def update
    if @hotel.update(hotel_params)
      redirect_to admin_hotels_path, notice: "Hotel was successfully updated."
    else
      render :index, status: :unprocessable_content
    end
  end

  private

  def set_hotel
    @hotel = Hotel.find(params[:id])
  end

  def hotel_params
    params.expect(hotel: [ :name, :email, :contact_no, :description, address_attributes: [ :dzongkhag, :gewog, :street_address ] ])
  end
end
