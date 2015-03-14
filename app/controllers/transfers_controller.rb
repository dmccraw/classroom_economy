class TransfersController < ApplicationController

  before_filter :get_group

  def index
    if params[:account_id]
      allow = current_user.teacher? || current_user.admin?
      unless allow
        account_ids = current_user.owns_or_manages_accounts(@group)
        allow = account_ids.detect { |id| params[:account_id].to_i == id }
      end
      if allow
        @transfers = @group.account_transfers(params[:account_id]).page(params[:page]).order("created_at DESC")
        @account = @group.accounts.find(params[:account_id])
      else
        authorize! :manage, @group
      end
    else
      if current_user.teacher? || current_user.admin?
        @transfers = @group.transfers.includes(:from_account, :to_account).page(params[:page]).order("created_at DESC")
      else
        account_ids = current_user.owns_or_manages_accounts(@group)

        @transfers = Transfer.where("to_account_id IN (:account_ids) OR from_account_id in (:account_ids)", account_ids: account_ids).page(params[:page]).order("created_at DESC")
      end
    end

    #authorize! :index, Account

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @transfers }
    end

  end

  # GET /transfers/new
  # GET /transfers/new.json
  def new
    @transfer = Transfer.new
    @transfer.group_id = @group.id

    @from_accounts = @group.accounts.includes(:owner).sort { |a,b| a.owner.display_name.downcase <=> b.owner.display_name.downcase }
    @to_accounts = @group.accounts.includes(:owner).sort { |a,b| a.owner.display_name.downcase <=> b.owner.display_name.downcase }
    @transfer.occurred_on = Date.today

    if params[:from_account_id].present?
      @from_account = Account.find_by_id(params[:from_account_id])
      @transfer.from_account_id = params[:from_account_id]
    end
    if params[:to_account_id].present?
      @to_account = Account.find_by_id(params[:to_account_id])
      @transfer.to_account_id = params[:to_account_id]
    end

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @user }
    end
  end

  # POST /transfers
  # POST /transfers.json
  def create
    params[:transfer][:occurred_on] = Time.strptime(params[:transfer][:occurred_on], "%m/%d/%Y") if params[:transfer][:occurred_on]
    @transfer = Transfer.new(params[:transfer])
    @transfer.user_id = current_user.id
    @transfer.group_id = @group.id

    @from_accounts = @group.accounts.includes(:owner).sort { |a,b| a.owner.display_name.downcase <=> b.owner.display_name.downcase }
    @to_accounts = @group.accounts.includes(:owner).sort { |a,b| a.owner.display_name.downcase <=> b.owner.display_name.downcase }

    if params[:from_account_id].present?
      @from_account = Account.find_by_id(params[:from_account_id])
      @transfer.from_account_id = params[:from_account_id]
    end
    if params[:to_account_id].present?
      @to_account = Account.find_by_id(params[:to_account_id])
      @transfer.to_account_id = params[:to_account_id]
    end

    respond_to do |format|
      if @transfer.save
        flash[:notice] = "Transfer was created."
        format.html { redirect_to group_path(@group) }
        format.json { @transfer.errors }
      else
        format.html { render action: "new" }
        format.json { @transfer.errors }
      end
    end
  end

  def new_class_transfer
    @transfer = Transfer.new
    if params[:from_account_id].present?
      @from_account = Account.find_by_id(params[:from_account_id])
    end
    if params[:to_account_id].present?
      @to_account = Account.find_by_id(params[:to_account_id])
    end
  end

  def create_class_transfer
    # check to make sure you have permission to create a class transfer
    # check for errors
    @transfer = Transfer.new
    @transfer.user_id = current_user.id
    @transfer.occurred_on = Time.strptime(params[:occurred_on], "%m/%d/%Y")
    transfer_attributes = {
      user_id: @transfer.user_id,
      occurred_on: @transfer.occurred_on
    }

    @transfer.amount = params[:amount]
    @transfer.description = params[:description]

    if params[:from_account_id].present?
      @from_account = Account.find_by_id(params[:from_account_id])
      @transfer.from_account_id = params[:from_account_id]
      @transfer.to_account_id = @group.users.first.account(@group.id).id
      transfer_attributes[:from_account_id] = params[:from_account_id]
    end

    if params[:to_account_id].present?
      @to_account = Account.find_by_id(params[:to_account_id])
      @transfer.to_account_id = params[:to_account_id]
      @transfer.from_account_id = @group.users.first.account(@group.id).id
      transfer_attributes[:to_account_id] = params[:to_account_id]
    end

    if @transfer.valid?
      # transfer_attibutes = {
      #   amount: @transfer.amount,
      #   description: @transfer.description
      # }
      # need to create transfers for all the members of the group
      @group.members.each do |member|
        unless member.teacher?
          if transfer_attributes[:to_account_id]
            new_transfer = Transfer.create!(
              user_id: @transfer.user_id,
              occurred_on: @transfer.occurred_on,
              from_account_id: member.account(@group.id).id,
              to_account_id: params[:to_account_id],
              amount: @transfer.amount,
              description: @transfer.description,
              group_id: @group.id
            )
          else
            new_transfer = Transfer.create!(
              user_id: @transfer.user_id,
              occurred_on: @transfer.occurred_on,
              to_account_id: member.account(@group.id).id,
              from_account_id: params[:from_account_id],
              amount: @transfer.amount,
              description: @transfer.description,
              group_id: @group.id
            )
          end
        end
      end

      respond_to do |format|
        flash[:notice] = "Transfers were created."
        if params[:from].present? && params[:from] == "store"
          format.html { redirect_to group_store_path(@group, @group.store) }
        else
          format.html { redirect_to group_path(@group) }
        end
        format.json { @transfer.errors }
      end
    else
      respond_to do |format|
        format.html { render action: "new_class_transfer" }
        format.json { @transfer.errors }
      end
    end
  end

  def undo
    @transfer = Transfer.find(params[:id])

    authorize! :undo, @transfer

    @transfer.undo

    respond_to do |format|
      flash[:notice] = "Transfer #{@transfer.id} has been undone."
      format.js { render text: "window.location.reload(true);"}
    end

  end

  private

  def get_group
    @group = Group.find(params[:group_id])
  end

end
