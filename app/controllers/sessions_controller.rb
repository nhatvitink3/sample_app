class SessionsController < ApplicationController
  before_action :load_user, only: :create
  before_action :check_authentication, only: :create
  before_action :check_active, only: :create

  CHECKED = "1".freeze

  # GET: /login
  def new; end

  # POST: /login
  def create
    forwarding_url = session[:forwarding_url]
    log_in @user
    if params.dig(:session, :remember_me) == CHECKED
      remember(@user)
    else
      forget(@user)
    end
    flash[:success] = t(".login_success")
    redirect_to forwarding_url || @user
  end

  # DELETE /logout
  def destroy
    log_out
    redirect_to root_url, status: :see_other
  end

  private

  def handle_failed
    flash.now[:danger] = t(".invalid_email_password_combination")
    render :new, status: :unprocessable_entity
  end

  def load_user
    @user = User.find_by(email: params.dig(:session, :email)&.downcase)
    return if @user

    handle_failed
  end

  def check_authentication
    return if @user.authenticate(params.dig(:session, :password))

    handle_failed
  end

  def check_active
    return if @user.activated?

    flash[:warning] = t(".account_not_activated")
    redirect_to root_url, status: :see_other
  end
end
