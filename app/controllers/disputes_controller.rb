class DisputesController < ApplicationController

  before_filter :get_group

  # GET /disputes
  # GET /disputes.json
  def index
    @disputes = @group.disputes.all

    # authorize! :show, @disputes

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @disputes }
    end
  end

  def show
    @dispute = Dispute.find(params[:id])

    authorize! :show, @dispute

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @dispute }
    end
  end

  # GET /disputes/new
  # GET /disputes/new.json
  def new

    @dispute = @group.disputes.new

    unless params[:transaction_id] || !(transaction = Transaction.find(params[:transaction_id]))
      flash[:notice] = "Invalid Transaction"
      redirect_to(:back)
      return
    end

    @dispute.transaction_id = params[:transaction_id]
    @dispute.owner_id = current_user.id
    @dispute.owner_type = current_user.class.to_s

    authorize! :create, @dispute

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @dispute }
    end
  end

  # GET /disputes/1/edit
  def edit
    @dispute = Dispute.find(params[:id])
    authorize! :update, @dispute
  end

  # POST /disputes
  # POST /disputes.json
  def create
    @dispute = Dispute.new(params[:dispute])

    authorize! :create, @dispute

    respond_to do |format|
      if @dispute.save
        format.html { redirect_to @group, notice: 'Dispute was successfully created.' }
        format.json { render json: @dispute, status: :created, location: @dispute }
      else
        format.html { render action: "new" }
        format.json { render json: @dispute.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /disputes/1
  # PUT /disputes/1.json
  def update
    @dispute = Dispute.find(params[:id])
    authorize! :update, @dispute

    @dispute.current_user_id = current_user.id

    respond_to do |format|
      if @dispute.update_attributes(params[:dispute])
        format.html { redirect_to @group, notice: 'Dispute was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @dispute.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /disputes/1
  # DELETE /disputes/1.json
  def destroy
    @dispute = Dispute.find(params[:id])
    authorize! :destroy, @dispute

    @dispute.destroy

    respond_to do |format|
      format.html { redirect_to @group }
      format.json { head :no_content }
    end
  end

  private

  def get_group
    @group = Group.find(params[:group_id])
Rails.logger.red(1)
    authorize! :read, @group
Rails.logger.red(2)
  end
end
