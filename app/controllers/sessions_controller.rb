class SessionsController < ApplicationController
  # GET: /login
  def new; end

  # POST: /login
  def create
    user = User.find_by email: params.dig(:session, :email)&.downcase
    if user&.authenticate params.dig(:session, :password)
      successful_login user
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
    log_in user
    flash[:success] = t(".login_success")
    redirect_to user, status: :see_other
  end

  def failed_login
    flash.now[:danger] = t(".invalid_email_password_combination")
    render :new, status: :unprocessable_entity
  end
end
