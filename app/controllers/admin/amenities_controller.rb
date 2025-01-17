class Admin::AmenitiesController < AdminController
  before_action :set_amenity, only: [ :edit, :update, :destroy ]
  before_action :set_hotel

  def index
    @amenities = @hotel.amenities.all.order(created_at: :desc)
  end

  def new
    @amenity = @hotel.amenities.new
  end

  def create
    # binding.pry
    @amenity = @hotel.amenities.new(amenity_params)
    if @amenity.save
      redirect_to admin_hotel_amenities_path(@hotel)
    else
      redirect_to admin_hotel_amenities_path(@hotel), status: :unprocessable_entity
    end
  end

  def edit; end

  def update
    if @amenity.update(amenity_params)
      redirect_to admin_hotel_amenities_path(@hotel)
    else
      redirect_to admin_hotel_amenities_path(@hotel), status: :unprocessable_entity
    end
  end

  def destroy
    @amenity.destroy
    redirect_to admin_hotel_amenities_path(@hotel)
  end

  private

  def set_hotel
    @hotel ||= Hotel.find(params[:hotel_id])
  end

  def set_amenity
    @hotel ||= Hotel.find(params[:hotel_id])
    @amenity ||= @hotel.amenities&.find(params[:id])
  end

  def amenity_params
    params.require(:amenity).permit(:name, :image)
  end
end
