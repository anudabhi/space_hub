class ApplicationController < ActionController::Base
  include Pagy::Backend

  allow_browser versions: :modern

  before_action :configure_permitted_parameters, if: :devise_controller?

  rescue_from CanCan::AccessDenied, with: :user_not_authorized

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: %i[name role phone city])
    devise_parameter_sanitizer.permit(:account_update, keys: %i[name phone bio city avatar])
  end

  private

  def user_not_authorized(exception)
    flash[:alert] = exception.message.presence || "You are not authorized to perform this action."
    redirect_back(fallback_location: root_path)
  end

  def require_host!
    unless current_user&.host? || current_user&.admin?
      flash[:alert] = "You need a host account to access this."
      redirect_to root_path
    end
  end

  def require_admin!
    unless current_user&.admin?
      flash[:alert] = "Admin access required."
      redirect_to root_path
    end
  end
end
