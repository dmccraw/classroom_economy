class RootController < ApplicationController
  def index
    if current_user
      case current_user.user_type
      when User::USER_TYPE_STUDENT
        render "student"
        return
      when User::USER_TYPE_TEACHER
        render "teacher"
        return
      when User::USER_TYPE_ADMIN
        render "admin"
        return
      end
    else
    end
  end

  def switch_user
    if user = User.find_by_id(params[:user_id])
      sign_in user
    end

    redirect_to action: "index"
  end
end
