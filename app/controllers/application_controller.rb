class ApplicationController < ActionController::Base
  protect_from_forgery

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
    Time.zone = (current_user ? current_user.time_zone : nil) || ClassroomEconomy::Application.config.time_zone
  end

  def set_locale
    I18n.locale = params[:locale] || I18n.default_locale
  end

  after_filter :set_csrf_cookie_for_ng
  def set_csrf_cookie_for_ng
    cookies['XSRF-TOKEN'] = form_authenticity_token if protect_against_forgery?
  end

  protected
    def verified_request?
      super || form_authenticity_token == request.headers['X-XSRF-TOKEN']
    end

end
