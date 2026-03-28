class Host::AvailabilitiesController < HostApplicationController
  before_action :set_listing

  def index
    @availabilities = @listing.availabilities.order(date: :asc, start_time: :asc)
    @availability = Availability.new
  end

  def create
    @availability = @listing.availabilities.build(availability_params)
    if @availability.save
      redirect_to host_listing_availabilities_path(@listing), notice: "Slot added."
    else
      @availabilities = @listing.availabilities.order(date: :asc)
      render :index, status: :unprocessable_entity
    end
  end

  def destroy
    @listing.availabilities.find(params[:id]).destroy
    redirect_to host_listing_availabilities_path(@listing), notice: "Slot removed."
  end

  private

  def set_listing
    @listing = current_user.listings.find(params[:listing_id])
  end

  def availability_params
    params.require(:availability).permit(:date, :start_time, :end_time, :is_available)
  end
end
