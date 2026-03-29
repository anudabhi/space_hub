class Admin::UsersController < AdminApplicationController
  before_action :set_user, only: %i[show edit update destroy]

  def index
    @pagy, @users = pagy(User.order(created_at: :desc))
  end

  def show; end

  def edit; end

  def update
    if @user.update(user_params)
      redirect_to admin_user_path(@user), notice: "User updated."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @user.destroy
    redirect_to admin_users_path, notice: "User deleted."
  end

  private

  def set_user
    @user = User.find(params[:id])
  end

  def user_params
    params.require(:user).permit(:name, :email, :role, :city, :host_approved) # brakeman:ignore:MassAssignment
  end
end
