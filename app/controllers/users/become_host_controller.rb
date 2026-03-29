class Users::BecomeHostController < UserApplicationController
  def update
    if current_user.guest?
      current_user.update!(role: "host")
      redirect_to host_root_path, notice: "Welcome! Your host account is ready. Create your first listing."
    else
      redirect_to root_path, alert: "You're already a host or admin."
    end
  end
end
