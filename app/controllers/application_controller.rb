class ApplicationController < ActionController::Base

  protect_from_forgery

  before_filter :authenticate_user!
  before_filter :set_time_zone
  before_filter :set_locale
  before_action :configure_permitted_parameters, if: :devise_controller?

  rescue_from CanCan::AccessDenied do |exception|
    # Rails.logger.red("Access denied on #{exception.action} #{exception.subject.inspect}")
    flash[:error] = exception.message
    redirect_to root_path
  end

  private

  def set_time_zone
    Time.zone = (current_user ? current_user.time_zone : nil) || ClassroomEconomy::Application.config.time_zone
  end

  def set_locale
    I18n.locale = params[:locale] || I18n.default_locale
  end

  protected

    def configure_permitted_parameters
      devise_parameter_sanitizer.for(:sign_up) << [:user_type, :first_name, :last_name, :email]
    end

end
