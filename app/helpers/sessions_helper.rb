module SessionsHelper
  def log_in user
    reset_session
    session[:user_id] = user.id
  end

  def log_in_from_cookies user_id
    user = User.find_by id: user_id
    return unless user&.authenticated?(:remember, cookies[:remember_token])

    log_in user
    @current_user = user
  end

  def current_user
    if (user_id = session[:user_id])
      @current_user ||= User.find_by id: user_id
    elsif (user_id = cookies.signed[:user_id])
      log_in_from_cookies(user_id)
    end
  end

  def current_user? user
    user == current_user
  end

  def forget user
    user.forget
    cookies.delete(:user_id)
    cookies.delete(:remember_token)
  end

  def logged_in?
    current_user.present?
  end

  def log_out
    forget current_user
    reset_session
    @current_user = nil
  end

  def remember user
    user.remember
    cookies.permanent.signed[:user_id] = user.id
    cookies.permanent[:remember_token] = user.remember_token
  end

  def store_location
    session[:forwarding_url] = request.original_url if request.get?
  end
end
