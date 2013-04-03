class BillsController < ApplicationController
  before_filter :get_group

  # GET /bills
  # GET /bills.json
  def index
    if current_user.student?
      @paid_bills = current_user.bills(@group).paid.page(params[:page])
      @unpaid_bills = current_user.bills(@group).unpaid.page(params[:page1])
    else
      @paid_bills = @group.bills.paid.page(params[:page])
      @unpaid_bills = @group.bills.unpaid.page(params[:page1])
    end

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @bills }
    end
  end

  # GET /bills/1
  # GET /bills/1.json
  def show
    @bill = Bill.find(params[:id])

    authorize! :read, @bill

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @bill }
    end
  end

  # GET /bills/new
  # GET /bills/new.json
  def new
    @bill = Bill.new
    @from_accounts = @group.accounts.includes(:owner).sort { |a,b| a.owner.display_name.downcase <=> b.owner.display_name.downcase }

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @bill }
    end
  end

  # GET /bills/1/edit
  def edit
    @from_accounts = @group.accounts.includes(:owner).sort { |a,b| a.owner.display_name.downcase <=> b.owner.display_name.downcase }
    @bill = Bill.find(params[:id])
  end

  # POST /bills
  # POST /bills.json
  def create
    @from_accounts = @group.accounts.includes(:owner).sort { |a,b| a.owner.display_name.downcase <=> b.owner.display_name.downcase }
    @bill = Bill.new(params[:bill])
    @bill.group_id = @group.id
    @bill.user_id = current_user.id
    @bill.to_account_id

    @bill.due_date = params[:bill][:due_date]

    unless current_user.student?
      @bill.to_account_id = @group.group_account.id
    else
      @bill.to_account_id = current_user.account(@group).id
    end

    authorize! :create, @bill

    respond_to do |format|
      if @bill.save
        format.html { redirect_to group_bills_path(@group), notice: 'Bill was successfully created.' }
        format.json { render json: @bill, status: :created, location: @bill }
      else
        format.html { render action: "new" }
        format.json { render json: @bill.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /bills/1
  # PUT /bills/1.json
  def update
    @to_accounts = @group.accounts.includes(:owner).sort { |a,b| a.owner.display_name.downcase <=> b.owner.display_name.downcase }
    @bill = Bill.find(params[:id])

    authorize! :udpate, @bill

    respond_to do |format|
      if @bill.update_attributes(params[:bill])
        format.html { redirect_to group_bills_path(@group), notice: 'Bill was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @bill.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /bills/1
  # DELETE /bills/1.json
  def destroy
    @bill = Bill.find(params[:id])

    authorize! :destroy, @bill

    @bill.destroy

    respond_to do |format|
      format.html { redirect_to group_bills_url(@group) }
      format.json { head :no_content }
    end
  end

  def pay_bill
    @bill = Bill.find(params[:id])

    authorize! :update, @bill

    if @bill.pay(current_user)
      flash[:notice] = "Bill has been paid."
    else
      flash[:notice] = @bill.errors.full_messages.join(", ")
    end

    respond_to do |format|
      if params[:redirect].present?
        format.html { redirect_to params[:redirect] }
      else
        format.html { redirect_to group_path(@group) }
      end
    end
  end

  private

  def get_group
    @group = Group.find(params[:group_id])

    authorize! :read, @group
  end
end
