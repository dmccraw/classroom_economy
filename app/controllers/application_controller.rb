class ApplicationController < ActionController::Base
  protect_from_forgery

  before_filter :authenticate_user!
  before_filter :set_time_zone

  rescue_from CanCan::AccessDenied do |exception|
    redirect_to root_path, :alert => exception.message
  end

  private

  def set_time_zone
    Time.zone = current_user.time_zone || ClassroomEconomy::Application.config.time_zone
  end

end
