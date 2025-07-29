class PasswordResetsController < ApplicationController
  before_action :load_user, :valid_user, :check_expiration,
                only: %i(edit update)
  before_action :load_user_by_email, only: %i(create)
  before_action :check_password_empty, only: %i(update)

  # GET /password_resets/new
  def new; end

  # POST /password_resets
  def create
    @user.create_reset_digest
    @user.send_password_reset_email
    flash[:info] = t(".email_sent")
    redirect_to root_url
  end

  # GET /password_resets/:id/edit
  def edit; end

  # PATCH /password_resets/:id
  def update
    if @user.update(user_params.merge(reset_digest: nil))
      log_in @user
      flash[:success] = t(".password_reset_success")
      redirect_to @user
    else
      render :edit, status: :unprocessable_entity
    end
  end

  private

  def user_params
    params.require(:user).permit(User::PASSWORD_RESET_PERMITTED)
  end

  def load_user
    @user = User.find_by email: params[:email]
    return if @user

    flash[:danger] = t("users.not_found_user")
    redirect_to root_url
  end

  def load_user_by_email
    @user = User.find_by email: params.dig(:password_reset, :email)&.downcase
    return if @user

    flash.now[:danger] = t(".email_not_found")
    render :new, status: :unprocessable_entity
  end

  def valid_user
    return if @user.activated && @user.authenticated?(:reset, params[:id])

    flash[:danger] = t(".account_not_activated")
    redirect_to root_url
  end

  def check_expiration
    return unless @user.password_reset_expired?

    flash[:danger] = t(".password_reset_expired")
    redirect_to new_password_reset_url
  end

  def check_password_empty
    return if user_params[:password].present?

    @user.errors.add :password, t(".empty_error")
    render :edit, status: :unprocessable_entity
  end
end
