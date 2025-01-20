class Admin::HotelGalleriesController < AdminController
  before_action :set_gallery, only: [ :show, :edit, :update, :destroy ]
  before_action :set_hotel

  def index
    @hotel_galleries = @hotel.hotel_galleries.all
  end

  def show; end

  def new
    @hotel_gallery = HotelGallery.new
  end

  def create
    @hotel_gallery = @hotel.hotel_galleries.new(hotel_gallery_params)
    if @hotel_gallery.save
      flash[:notice] = "Hotel Gallery was successfully created."
      redirect_to admin_hotel_galleries_path(@hotel)
    else
      flash[:alert] = "Hotel Gallery failed to be created."
      render :new, status: :unprocessable_entity
    end
  end

  def edit; end

  def update
    if @hotel_gallery.update(hotel_gallery_params.reject { |k| k["images"] })
      if hotel_gallery_params[:images]
        hotel_gallery_params[:images].each do |image|
          @hotel_gallery.images.attach(image)
        end
      end
      flash[:notice] = "Gallery was successfully updated"
      redirect_to admin_hotel_galleries_path(@hotel)
    else
      flash[:alert] = "Error updating gallery"
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @hotel_gallery.destroy
    # respond_to do |format|
    #   format.html { redirect_to admin_hotel_amenities_path(@hotel) }
    #   format.turbo_stream do
    #     flash.now[:notice] = "Amenity successfully removed!"
    #     render turbo_stream: [
    #       turbo_stream.remove(@amenity),
    #       turbo_stream.prepend("flash", partial: "shared/flash")
    #     ]
    #   end
    flash[:notice] = "Gallery was successfully destroyed"
    redirect_to admin_hotel_galleries_path(@hotel)
  end

  private

  def set_hotel
    @hotel ||= Hotel.find(params[:hotel_id])
  end

  def set_gallery
    @hotel ||= Hotel.find(params[:hotel_id])
    @hotel_gallery ||= @hotel.hotel_galleries&.find(params[:id])
    rescue ActiveRecord::RecordNotFound
      flash[:alert] = "Hotel Gallery not found"
      redirect_to admin_hotel_galleries_path(@hotel)
  end

  def hotel_gallery_params
    params.require(:hotel_gallery).permit(:name, :description, images: [])
  end
end
