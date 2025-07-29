class UsersController < ApplicationController
  before_action :load_user, only: %i(show)

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

  private

  def user_params
    params.require(:user).permit User::USER_PERMIT
  end

  def load_user
    @user = User.find_by id: params[:id]
    return if @user

    flash[:warning] = t(".not_found_user")
    redirect_to root_path
  end
end
