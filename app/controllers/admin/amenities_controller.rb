class Admin::AmenitiesController < AdminController
  before_action :set_amenity, only: [ :edit, :update, :destroy ]
  before_action :set_hotel

  def index
    if params[:query].present?
      @pagy, @amenities = pagy(@hotel.amenities.where("name LIKE ?", "%#{params[:query]}%").order(created_at: :desc))
    else
      @pagy, @amenities = pagy(@hotel.amenities.order(created_at: :desc), items: 5)
    end
  end

  def new
    @amenity = @hotel.amenities.new
  end

  def create
    @amenity = @hotel.amenities.new(amenity_params)
    if @amenity.save
      flash[:notice] = "Amenity successfully added"
      redirect_to admin_hotel_amenities_path(@hotel)
    else
      flash[:alert] = "Error adding amenity"
      render :new, status: :unprocessable_content
    end
  end

  def edit; end

  def update
    if @amenity.update(amenity_params.except(:image))
      if amenity_params[:image].present? && amenity_params[:image].is_a?(ActionDispatch::Http::UploadedFile)
        @amenity.image.attach(amenity_params[:image])
      end
      flash[:notice] = "Amenity successfully updated"
      redirect_to admin_hotel_amenities_path(@hotel)
    else
      flash[:alert] = "Error updating amenity"
      render :edit, status: :unprocessable_content
    end
  end

  def destroy
    @amenity.destroy
    respond_to do |format|
      format.html { redirect_to admin_hotel_amenities_path(@hotel) }
      format.turbo_stream do
        flash.now[:notice] = "Amenity successfully removed!"
        render turbo_stream: [
          turbo_stream.remove(@amenity),
          turbo_stream.prepend("flash", partial: "shared/flash")
        ]
      end
    end
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
