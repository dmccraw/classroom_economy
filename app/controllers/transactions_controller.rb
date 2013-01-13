class TransactionsController < ApplicationController

  before_filter :get_group

  def index
    if params[:account_id]
      @transactions = @group.account_transactions(params[:account_id]).page(params[:page]).order("created_at DESC")
      @account = @group.accounts.find(params[:account_id])
    else
      @transactions = @group.transactions.page(params[:page]).order("created_at DESC")
    end

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @transactions }
    end

  end

  # GET /transactions/new
  # GET /transactions/new.json
  def new
    @transaction = Transaction.new
    @transaction.group_id = @group.id

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
    @transaction.group_id = @group.id

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

  def new_class_transaction
    @transaction = Transaction.new
    if params[:from_account_id].present?
      @from_account = Account.find_by_id(params[:from_account_id])
    end
    if params[:to_account_id].present?
      @to_account = Account.find_by_id(params[:to_account_id])
    end
  end

  def create_class_transaction
    # check to make sure you have permission to create a class transaction
    # check for errors
    @transaction = Transaction.new
    @transaction.user_id = current_user.id
    @transaction.occurred_on = DateTime.now
    transaction_attributes = {
      user_id: @transaction.user_id,
      occurred_on: @transaction.occurred_on
    }

    @transaction.amount = params[:amount]
    @transaction.description = params[:description]
    if params[:from_account_id].present?
      @from_account = Account.find_by_id(params[:from_account_id])
      @transaction.from_account_id = params[:from_account_id]
      @transaction.to_account_id = @group.accounts.where("owner_id <> ?",current_user.id).first.id
      transaction_attributes[:from_account_id] = params[:from_account_id]
    end
    if params[:to_account_id].present?
      @to_account = Account.find_by_id(params[:to_account_id])
      @transaction.to_account_id = params[:to_account_id]
      @transaction.from_account_id = @group.accounts.where("owner_id <> ?",current_user.id).first.id
      transaction_attributes[:to_account_id] = params[:to_account_id]
    end

    if @transaction.valid?
      transaction_attibutes = {
        amount: @transaction.amount,
        description: @transaction.description
      }
      # need to create transactions for all the members of the group
      @group.members.each do |member|
        unless member.teacher?
          if transaction_attributes[:to_account_id]
            new_transaction = Transaction.create!(
              user_id: @transaction.user_id,
              occurred_on: @transaction.occurred_on,
              from_account_id: member.account(@group.id).id,
              to_account_id: params[:to_account_id],
              amount: @transaction.amount,
              description: @transaction.description,
              group_id: @group.id
            )
          else
            new_transaction = Transaction.create!(
              user_id: @transaction.user_id,
              occurred_on: @transaction.occurred_on,
              to_account_id: member.account(@group.id).id,
              from_account_id: params[:from_account_id],
              amount: @transaction.amount,
              description: @transaction.description,
              group_id: @group.id
            )
          end
        end
      end
      respond_to do |format|
        flash[:notice] = "Transactions were created."
        format.html { redirect_to group_path(@group) }
        format.json { @transaction.errors }
      end
    else
      respond_to do |format|
        format.html { render action: "new_class_transaction" }
        format.json { @transaction.errors }
      end
    end
  end

  private

  def get_group
    @group = Group.find(params[:group_id])
  end

end
