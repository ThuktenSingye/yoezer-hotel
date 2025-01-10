class Admin::HotelsController < ApplicationController
  layout "admin"

  before_action :set_hotel, only: [ :edit, :update ]
  before_action :authenticate_admin!

  def index
    @hotel = Hotel.includes(:address).first
    @hotel_ratings = Hotel.includes(:hotel_ratings).average(:rating)
    @rating = {
      full_stars: @hotel_ratings.to_i,
      half_stars: @hotel_ratings - (@hotel_ratings.to_i) >=0.5,
      empty_stars: 5 - (@hotel_ratings.to_i)- ((@hotel_ratings - (@hotel_ratings.to_i)) ? 1: 0)
    }
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
