class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  include SessionsHelper
  include Pagy::Backend

  before_action :set_locale

  def set_locale
    valid_locales = I18n.available_locales.map(&:to_s)
    locale = params[:locale]

    I18n.locale = valid_locales.include?(locale) ? locale : I18n.default_locale
  end

  def default_url_options
    {locale: I18n.locale}
  end
end
