class ApplicationController < ActionController::Base
  protect_from_forgery

  before_filter :authenticate_user!

  helper_method :get_current_group_id, :get_current_group

  def get_current_group_id
# Rails.logger.red("get_current_group_id")
# Rails.logger.red(current_user.inspect)
# Rails.logger.red(current_user.groups)
# Rails.logger.red(current_user.groups.first)
# Rails.logger.red(current_user.groups.first.id)
    unless session[:current_group_id]
      if current_user.teacher? && current_user.groups.first
        session[:current_group_id] = current_user.groups.first.id
      elsif current_user.student? && current_user.groups.first
        session[:current_group_id] = current_user.groups.first.id
      end
    end
    session[:current_group_id]
  end

  def get_current_group
    @current_group ||= Group.find_by_id(get_current_group_id)
  end

end
