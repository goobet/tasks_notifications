class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.

  protect_from_forgery with: :exception
  before_filter :configure_permitted_parameters, if: :devise_controller?
  before_action :set_locale
  before_action :authenticate_user!

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.for(:sign_up) << :name
  end


  def set_locale
    locale = params[:locale]
    
    if locale.blank? 
      I18n.locale = session[:locale] || I18n.default_locale
      logger.error("locale blank #{session[locale]}")
      return
    end

    if I18n.available_locales.map(&:to_s).include?(locale)
      I18n.locale = locale
      session[:locale] = locale
      logger.error("set locale to #{locale}")
    else
      flash.now[:notice] = "#{locale} translation not available"
    end
  end
end
