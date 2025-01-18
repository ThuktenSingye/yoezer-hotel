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
    @amenity = @hotel.amenities.new(amenity_params)
    respond_to do |format|
      if @amenity.save
        format.html { redirect_to admin_hotel_amenities_path(@hotel) }
        format.turbo_stream do
          flash.now[:notice] = "Amenity successfully added"
          render turbo_stream: [
            turbo_stream.prepend("amenities", partial: "admin/amenities/amenity", locals: { amenity: @amenity }),
            turbo_stream.prepend("flash", partial: "layouts/flash")
          ]
        end
      else
        format.html { render :new, status: :unprocessable_entity }
        format.turbo_stream do
          flash.now[:alert] = "Amenity failed to add"
          turbo_stream.prepend("flash", partial: "layouts/flash")
        end
      end
    end
  end

  def edit; end

  def update
    respond_to do |format|
      if @amenity.update(amenity_params.except(:image))
        if amenity_params[:image].present?
          @amenity.image.attach(amenity_params[:image])
        end
        format.html { redirect_to admin_hotel_amenities_path(@hotel), status: :see_other }
        format.turbo_stream do
          flash.now[:notice] = "Amenity was successfully updated."
          render turbo_stream: [
            turbo_stream.replace(@amenity, partial: "admin/amenities/amenity", locals: { amenity: @amenity }),
            turbo_stream.prepend("flash", partial: "layouts/flash")
          ]
        end
      else
        format.html { render :edit, status: :unprocessable_content }
        format.turbo_stream do
          flash.now[:alert] = "Error updating Amenity"
          render turbo_stream: [
            turbo_stream.replace(@profile, partial: "admin/amenities/amenity", locals: { amenity: @amenity }),
            turbo_stream.prepend("flash", partial: "layouts/flash")
          ]
        end
      end
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
          turbo_stream.prepend("flash", partial: "layouts/flash")
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
