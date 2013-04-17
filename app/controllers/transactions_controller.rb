class TransactionsController < ApplicationController

  before_filter :get_group

  def index
    if params[:account_id]
      allow = current_user.teacher? || current_user.admin?
      unless allow
        account_ids = current_user.owns_or_manages_accounts(@group)
        allow = account_ids.detect { |id| params[:account_id].to_i == id }
      end
      if allow
        @transactions = @group.account_transactions(params[:account_id]).page(params[:page]).order("created_at DESC")
        @account = @group.accounts.find(params[:account_id])
      else
        authorize! :manage, @group
      end
    else
      if current_user.teacher? || current_user.admin?
        @transactions = @group.transactions.page(params[:page]).order("created_at DESC")
      else
        account_ids = current_user.owns_or_manages_accounts(@group)

        @transactions = Transaction.where("to_account_id IN (:account_ids) OR from_account_id in (:account_ids)", account_ids: account_ids).page(params[:page]).order("created_at DESC")
      end
    end

    #authorize! :index, Account

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

    @from_accounts = @group.accounts.includes(:owner).sort { |a,b| a.owner.display_name.downcase <=> b.owner.display_name.downcase }
    @to_accounts = @group.accounts.includes(:owner).sort { |a,b| a.owner.display_name.downcase <=> b.owner.display_name.downcase }
    @transaction.occurred_on = Date.today

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
    @transaction.occurred_on = Time.strptime(params[:transaction][:occurred_on], "%m/%d/%Y")
    @transaction.group_id = @group.id

    @from_accounts = @group.accounts.includes(:owner).sort { |a,b| a.owner.display_name.downcase <=> b.owner.display_name.downcase }
    @to_accounts = @group.accounts.includes(:owner).sort { |a,b| a.owner.display_name.downcase <=> b.owner.display_name.downcase }

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
    @transaction.occurred_on = Time.strptime(params[:occurred_on], "%m/%d/%Y")
    transaction_attributes = {
      user_id: @transaction.user_id,
      occurred_on: @transaction.occurred_on
    }

    @transaction.amount = params[:amount]
    @transaction.description = params[:description]
    if params[:from_account_id].present?
      @from_account = Account.find_by_id(params[:from_account_id])
      @transaction.from_account_id = params[:from_account_id]
      @transaction.to_account_id = @group.users.first.account(@group.id).id
      transaction_attributes[:from_account_id] = params[:from_account_id]
    end
    if params[:to_account_id].present?
      @to_account = Account.find_by_id(params[:to_account_id])
      @transaction.to_account_id = params[:to_account_id]
      @transaction.from_account_id = @group.users.first.account(@group.id).id
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
        if params[:from].present? && params[:from] == "store"
          format.html { redirect_to group_store_path(@group, @group.store) }
        else
          format.html { redirect_to group_path(@group) }
        end
        format.json { @transaction.errors }
      end
    else
      respond_to do |format|
        format.html { render action: "new_class_transaction" }
        format.json { @transaction.errors }
      end
    end
  end

  def undo
    @transaction = Transaction.find(params[:id])

    authorize! :undo, @transaction

    @transaction.undo

    respond_to do |format|
      flash[:notice] = "Transaction #{@transaction.id} has been undone."
      format.js { render text: "window.location.reload(true);"}
    end

  end

  private

  def get_group
    @group = Group.find(params[:group_id])
  end

end
