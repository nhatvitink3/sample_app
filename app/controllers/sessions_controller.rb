class SessionsController < ApplicationController
  CHECKED = "1".freeze

  # GET: /login
  def new; end

  # POST: /login
  def create
    user = User.find_by email: params.dig(:session, :email)&.downcase
    if user.try(:authenticate, params.dig(:session, :password))
      successful_login(user)
    else
      failed_login
    end
  end

  # DELETE /logout
  def destroy
    log_out
    redirect_to root_url, status: :see_other
  end

  private

  def successful_login user
    forwarding_url = session[:forwarding_url]
    log_in user
    if params.dig(:session, :remember_me) == CHECKED
      remember(user)
    else
      forget(user)
    end
    redirect_to forwarding_url || user
  end

  def failed_login
    flash.now[:danger] = t(".invalid_email_password_combination")
    render :new, status: :unprocessable_entity
  end
end
