class ApplicationController < ActionController::Base
  protect_from_forgery

  before_filter :authenticate_user!
  before_filter :set_time_zone

  rescue_from CanCan::AccessDenied do |exception|
    Rails.logger.red(exception.inspect)
    flash[:error] = exception.message
    redirect_to root_path, :notice => exception.message
  end

  private

  def set_time_zone
    Time.zone = (current_user ? current_user.time_zone : nil) || ClassroomEconomy::Application.config.time_zone
  end

end
