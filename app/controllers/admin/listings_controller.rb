class Admin::ListingsController < AdminApplicationController
  before_action :set_listing, only: %i[show edit update destroy approve]

  def index
    @pagy, @listings = pagy(Listing.includes(:user).order(created_at: :desc))
  end

  def show; end
  def edit; end

  def update
    if @listing.update(listing_params)
      redirect_to admin_listing_path(@listing), notice: "Listing updated."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @listing.destroy
    redirect_to admin_listings_path, notice: "Listing deleted."
  end

  def approve
    @listing.update!(status: "active")
    redirect_to admin_listing_path(@listing), notice: "Listing approved."
  end

  private

  def set_listing
    @listing = Listing.find(params[:id])
  end

  def listing_params
    params.require(:listing).permit(:title, :description, :category, :city, :status, :price_per_hour, :capacity)
  end
end
