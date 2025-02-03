class Admin::HotelGalleriesController < AdminController
  before_action :set_gallery, only: [ :show, :edit, :update, :destroy ]
  before_action :set_hotel

  def index
    @hotel_galleries = @hotel.hotel_galleries.all.order(created_at: :desc)
  end

  def show; end

  def new
    @hotel_gallery = @hotel.hotel_galleries.new
  end

  def create
    @hotel_gallery = @hotel.hotel_galleries.new(hotel_gallery_params)
    if @hotel_gallery.save
      flash[:notice] = "Hotel Gallery was successfully created."
      redirect_to admin_hotel_hotel_galleries_path(@hotel)
    else
      flash[:alert] = "Hotel Gallery failed to be created."
      render :new, status: :unprocessable_entity
    end
  end

  def edit; end

  def update
    if @hotel_gallery.update(hotel_gallery_params.except(:image))
      if hotel_gallery_params[:image] && hotel_gallery_params[:image].is_a?(ActionDispatch::Http::UploadedFile)
          @hotel_gallery.image.attach(hotel_gallery_params[:image])
      end
      flash[:notice] = "Gallery was successfully updated"
      redirect_to admin_hotel_hotel_galleries_path(@hotel)
    else
      flash[:alert] = "Error updating gallery"
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @hotel_gallery.destroy
    flash[:notice] = "Gallery successfully removed!"
    redirect_to admin_hotel_hotel_galleries_path(@hotel)
  end

  private

  def set_hotel
    @hotel ||= Hotel.find(params[:hotel_id])
  end

  def set_gallery
    @hotel ||= Hotel.find(params[:hotel_id])
    @hotel_gallery = @hotel&.hotel_galleries&.find(params[:id])
    rescue ActiveRecord::RecordNotFound
      flash.now[:alert] = "Hotel Gallery not found"
      redirect_to admin_hotel_hotel_galleries_path(@hotel)
  end

  def hotel_gallery_params
    params.require(:hotel_gallery).permit(:name, :description, :image)
  end
end
