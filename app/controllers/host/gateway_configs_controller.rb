class Host::GatewayConfigsController < HostApplicationController
  def index
    @razorpay = current_user.gateway_configs.find_or_initialize_by(gateway: "razorpay")
    @stripe   = current_user.gateway_configs.find_or_initialize_by(gateway: "stripe")
  end

  def upsert
    @config = current_user.gateway_configs.find_or_initialize_by(gateway: params[:gateway])
    @config.assign_attributes(gateway_config_params)

    if @config.save
      redirect_to host_gateway_configs_path, notice: "#{params[:gateway].capitalize} settings saved."
    else
      @razorpay = current_user.gateway_configs.find_or_initialize_by(gateway: "razorpay")
      @stripe   = current_user.gateway_configs.find_or_initialize_by(gateway: "stripe")
      # Overwrite the one we just tried to save so errors render
      instance_variable_set("@#{params[:gateway]}", @config)
      render :index, status: :unprocessable_entity
    end
  end

  private

  def gateway_config_params
    params.require(:gateway_config).permit(:key_id, :key_secret, :active)
  end
end
