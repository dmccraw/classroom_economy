class ApplicationController < ActionController::Base
  before_action :configure_permitted_parameters, if: :devise_controller?
  before_filter :authenticate_user!
  before_filter :set_time_zone
  before_filter :set_locale

  rescue_from CanCan::AccessDenied do |exception|
    # Rails.logger.red("Access denied on #{exception.action} #{exception.subject.inspect}")
    flash[:error] = exception.message
    redirect_to root_path
  end

  private

  def set_time_zone
    Time.zone = (current_user ? current_user.time_zone : nil) || Rails.application.config.time_zone
  end

  def set_locale
    I18n.locale = params[:locale] || I18n.default_locale
  end
    # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.for(:sign_up) { |u| u.permit(:user_type, :first_name, :last_name, :email, :password, :password_confirmation) }
  end

end
