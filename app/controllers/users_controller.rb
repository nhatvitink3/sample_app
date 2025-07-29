class UsersController < ApplicationController
  before_action :load_user, only: %i(show edit update destroy)
  before_action :logged_in_user, only: %i(show edit update destroy)
  before_action :correct_user, only: %i(show edit update)
  before_action :admin_user, only: :destroy

  # GET /signup
  def new
    @user = User.new
  end

  # GET /user
  def show; end

  # POST /signup
  def create
    @user = User.new(user_params)
    if @user.save
      log_in @user
      flash[:success] = t("static_pages.home.welcome")
      redirect_to @user, status: :see_other
    else
      render :new, status: :unprocessable_entity
    end
  end

  def forget
    update_column :remember_digest, nil
  end

  # GET /users/:id/edit
  def edit; end

  # PATCH /users/:id
  def update
    if @user.update user_params
      flash[:success] = t(".profile_updated")
      redirect_to @user
    else
      render :edit, status: :unprocessable_entity
    end
  end

  # GET /users
  def index
    @pagy, @users = pagy User.recent, items: Settings.page_10
  end

  # DELETE /users/:id
  def destroy
    if @user.destroy
      flash[:success] = t(".user_deleted")
    else
      flash[:danger] = t(".delete_failed")
    end
    redirect_to users_path
  end

  private

  def user_params
    params.require(:user).permit User::USER_PERMIT
  end

  def load_user
    @user = User.find_by id: params[:id]
    return if @user

    flash[:warning] = t("users.not_found_user")
    redirect_to root_path
  end

  def admin_user
    return if current_user&.admin?

    flash[:danger] = t("users.not_admin")
    redirect_to root_path, status: :see_other
  end

  def logged_in_user
    return if logged_in?

    store_location
    flash[:danger] = t("users.please_login")
    redirect_to login_path, status: :see_other
  end

  def correct_user
    return if current_user?(@user) || current_user.admin?

    flash[:danger] = t("users.not_correct_user")
    redirect_to root_path, status: :see_other
  end
end
