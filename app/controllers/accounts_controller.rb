class AccountsController < ApplicationController

  before_filter :get_group

  # GET /account/1
  # GET /account/1.json
  def show
    @account = Account.find(params[:id])
    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @account }
    end
  end

  private

  def get_group
    @group = Group.find(params[:group_id])
  end

end

