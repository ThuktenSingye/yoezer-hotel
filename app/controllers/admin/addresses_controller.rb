class Admin::AddressesController < AdminController
  before_action :set_hotel, only: [ :new, :create, :destroy ]
  before_action :set_address, only: [ :destroy ]

  def new
    @address = Address.new
  end

  def create
    @address = @hotel.address.build(address_params)
    if @address.save
      respond_to do |format|
        format.html { redirect_to admin_hotel_path(@hotel) }
        format.turbo_stream do
          flash[:notice] = "Address successfully added"
          render turbo_stream: [
            turbo_stream.prepend("new_address", partial: "admin/hotels/hotel", locals: { address: @address }),
            turbo_stream.prepend("flash", partial: "layouts/flash", locals: { message: "Address successfully added", type: :notice })
          ]
        end
      end
    else
      respond_to do |format|
        format.html { redirect_to admin_hotels_path(@hotel), status: :unprocessable_content }
        format.turbo_stream do
          flash.now[:alert] = "Error updating Hotel"
          render turbo_stream: [
            turbo_stream.prepend("flash", partial: "layouts/flash")
          ]
        end
      end
    end
  end

  def destroy
    @address.destroy
    respond_to do |format|
      format.html { redirect_to admin_hotels_path }
      format.turbo_stream do
        flash[:notice] = "Address successfully removed!"
        render turbo_stream: [
          turbo_stream.remove(@address),
          turbo_stream.prepend("flash", partial: "layouts/flash")
        ]
      end
    end
  end

  private

  def address_params
    params.require(:address).permit(:dzongkhag, :gewog, :street_address)
  end

  def set_hotel
    @hotel ||= Hotel.find(params[:hotel_id])
  end

  def set_address
    @address ||= Address.find(params[:id])
    rescue ActiveRecord::RecordNotFound
      redirect_to admin_path, alert: "Address not found"
  end
end
