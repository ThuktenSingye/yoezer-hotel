class Admin::HotelsController < ApplicationController
  layout "admin"

  before_action :set_hotel, only: [ :edit, :update ]
  before_action :set_rating, only: [ :index, :update ]
  before_action :authenticate_admin!

  def index
    @hotel = Hotel.includes(:address).first
  end

  def edit; end

  def update
    if @hotel.update(hotel_params)
      respond_to do |format|
        format.html { redirect_to admin_hotels_path, notice: "Hotel was successfully updated." }
        format.turbo_stream do
          flash.now[:notice] = "Hotel was successfully updated."
          render turbo_stream: [
            turbo_stream.replace(@hotel, partial: "admin/hotels/hotel", locals: { hotel: @hotel }),
            turbo_stream.prepend("flash", partial: "layouts/flash")
          ]
        end
      end
    else
      respond_to do |format|
        format.html { render :index, status: :unprocessable_content, notice: "Error updating Hotel" }
        format.turbo_stream do
          flash.now[:alert] = "Error updating Hotel"
          render turbo_stream: [
            turbo_stream.replace(@hotel, partial: "admin/hotels/form", locals: { hotel: @hotel }),
            turbo_stream.prepend("flash", partial: "layouts/flash")
          ]
        end
      end
    end
  end

  private

  def set_hotel
    @hotel = Hotel.find(params[:id])
  end

  def set_rating
    @hotel_ratings = Hotel.includes(:hotel_ratings).average(:rating) || 0
    @rating = {
      full_stars: @hotel_ratings.to_i,
      half_stars: @hotel_ratings - (@hotel_ratings.to_i) >=0.5,
      empty_stars: 5 - (@hotel_ratings.to_i)- ((@hotel_ratings - (@hotel_ratings.to_i)) ? 1: 0)
    }
  end

  def hotel_params
    params.expect(hotel: [ :name, :email, :contact_no, :description, address_attributes: [ :id, :dzongkhag, :gewog, :street_address ] ])
  end
end
