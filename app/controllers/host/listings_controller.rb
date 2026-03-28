class Host::ListingsController < HostApplicationController
  before_action :set_listing, only: %i[show edit update destroy]

  def index
    @listings = current_user.listings.order(created_at: :desc)
  end

  def show
    authorize! :read, @listing
    @reviews  = @listing.reviews.includes(:user).order(created_at: :desc)
    @bookings = @listing.bookings.includes(:user).order(start_time: :desc).limit(10)
  end

  def new
    @listing = current_user.listings.build
    authorize! :create, @listing
  end

  def create
    @listing = current_user.listings.build(listing_params)
    @listing.status = "active"
    authorize! :create, @listing
    if @listing.save
      redirect_to host_listing_path(@listing), notice: "Listing created!"
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    authorize! :update, @listing
  end

  def update
    authorize! :update, @listing
    if @listing.update(listing_params)
      redirect_to host_listing_path(@listing), notice: "Listing updated."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    authorize! :destroy, @listing
    @listing.destroy
    redirect_to host_listings_path, notice: "Listing deleted."
  end

  private

  def set_listing
    @listing = current_user.listings.find(params[:id])
  end

  def listing_params
    params.require(:listing).permit(
      :title, :description, :category, :city, :address,
      :price_per_hour, :capacity, :amenities, :status,
      photos: [], accepted_gateways: []
    )
  end
end
