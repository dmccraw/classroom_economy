class RootController < ApplicationController
  def index
    case current_user.user_type
    when User::USER_TYPE_STUDENT
      if current_user.groups.count == 1
        redirect_to group_path(id: current_user.groups.first.id)
      else
        render "student"
        return
      end
    when User::USER_TYPE_TEACHER
      if current_user.groups.count == 1
        redirect_to group_path(id: current_user.groups.first.id)
      else
        render "teacher"
        return
      end
    when User::USER_TYPE_ADMIN
      render "admin"
      return
    end
  end

  def switch_user
    if user = User.find_by_id(params[:user_id])
      sign_in user
    end

    redirect_to action: "index"
  end
end
