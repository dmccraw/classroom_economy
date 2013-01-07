class TransactionsController < ApplicationController

  before_filter :get_group

  # GET /transactions/new
  # GET /transactions/new.json
  def new
    @transaction = Transaction.new

    @from_accounts = @group.accounts
    @to_accounts = @group.accounts

    if params[:from_account_id].present?
      @from_account = Account.find_by_id(params[:from_account_id])
      @transaction.from_account_id = params[:from_account_id]
    end
    if params[:to_account_id].present?
      @to_account = Account.find_by_id(params[:to_account_id])
      @transaction.to_account_id = params[:to_account_id]
    end

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @user }
    end
  end

  # POST /transactions
  # POST /transactions.json
  def create
    @transaction = Transaction.new(params[:transaction])
    @transaction.user_id = current_user.id
    @transaction.occurred_on = DateTime.now

    @from_accounts = @group.accounts
    @to_accounts = @group.accounts

    if params[:from_account_id].present?
      @from_account = Account.find_by_id(params[:from_account_id])
      @transaction.from_account_id = params[:from_account_id]
    end
    if params[:to_account_id].present?
      @to_account = Account.find_by_id(params[:to_account_id])
      @transaction.to_account_id = params[:to_account_id]
    end

    respond_to do |format|
      if @transaction.save
        flash[:notice] = "Transaction was created."
        format.html { redirect_to group_path(@group) }
        format.json { @transaction.errors }
      else
        format.html { render action: "new" }
        format.json { @transaction.errors }
      end
    end
  end

  private

  def get_group
    @group = Group.find(params[:group_id])
  end

end
