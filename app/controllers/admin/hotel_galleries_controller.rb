class Admin::HotelGalleriesController < AdminController

  def index

  end

  def show

  end

  def new

  end

  def create

  end

  def edit

  end

  def update

  end

  def destroy


  end

  private

  def set_hotel
    @hotel = Hotel.find(params[:hotel_id])
  end

  def set_gallery
    @hotel = Hotel.find(params[:hotel_id])
    # @gallery =
  end

  def hotel_gallery_params
    params.require(:hotel_gallery).permit(:name, :description, images: [])
  end
end
