class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  before_action :set_locale
  before_action :redirect_to_token

  def set_locale
    I18n.locale = params[:locale] || I18n.default_locale
  end

  def token_mode?
    cookies[:token_mode]
  end

  def redirect_to_token
    if token_mode? && !devise_controller?
      redirect_to token_path
    end
  end
end
