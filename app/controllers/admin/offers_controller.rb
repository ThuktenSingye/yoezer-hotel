class Admin::OffersController < AdminController
  before_action :set_hotel
  before_action :set_offer, only: [ :show, :edit, :update, :destroy ]
  def index
    @offer = @hotel.offers.all.order(created_at: :desc)
  end

  def show; end

  def new
    @offer = @hotel.offers.new
  end

  def create
    @offer = @hotel.offers.new(offer_params)
    if @offer.save
      flash[:notice] = "Successfully created offer."
      redirect_to admin_hotel_offers_path(@hotel)
    else
      flash[:alert] = "Error creating offer"
      render :new, status: :unprocessable_entity
    end
  end

  def edit; end

  def update
    # binding.pry
    if @offer.update(offer_params.except(:image))
      if offer_params[:image] && offer_params[:image].is_a?(ActionDispatch::Http::UploadedFile)
        @offer.image.attach(offer_params[:image])
      end
      flash[:notice] = "Offer was successfully updated"
      redirect_to admin_hotel_offer_path(@hotel, @offer)
    else
      flash[:alert] = "Error updating Offer"
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @offer.destroy
    redirect_to admin_hotel_offer_path(@hotel, @offer)
  end

  private

  def set_hotel
    @hotel ||= Hotel.find(params[:hotel_id])
  end

  def set_offer
    @hotel ||= Hotel.find(params[:hotel_id])
    @offer ||= @hotel.offers&.find(params[:id])
    rescue ActiveRecord::RecordNotFound
      flash.now[:alert] = "Hotel Gallery not found"
      redirect_to admin_hotel_offers_path(@hotel)
  end

  def offer_params
    params.require(:offer).permit(:title, :description, :start_time, :end_time, :discount, :image)
  end
end
