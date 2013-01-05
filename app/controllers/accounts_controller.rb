class AccountsController < ApplicationController

  # GET /account/1
  # GET /account/1.json
  def show
    @account = Account.find(params[:id])
    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @account }
    end
  end

end

