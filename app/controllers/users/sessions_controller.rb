class Users::SessionsController < Devise::SessionsController
  protected

  def after_sign_in_path_for(resource)
    if resource.admin?
      admin_root_path
    elsif resource.host?
      host_root_path
    else
      guest_root_path
    end
  end
end
