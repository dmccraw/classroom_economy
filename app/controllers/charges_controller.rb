class ChargesController < ApplicationController

  before_filter :get_group

  # GET /charges
  # GET /charges.json
  def index
    if current_user.student?
      @charges = current_user.charges(@group).includes(account: :owner)
    else
      @charges = @group.charges.includes(account: :owner).all
    end

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @charges }
    end
  end

  # GET /charges/1
  # GET /charges/1.json
  def show
    @charge = @group.charges.find(params[:id])

    authorize! :read, @charge

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @charge }
    end
  end

  # GET /charges/new
  # GET /charges/new.json
  def new
    @charge = @group.charges.new
    @accounts = @group.accounts

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @charge }
    end
  end

  # GET /charges/1/edit
  def edit
    @charge = Charge.find(params[:id])
    @accounts = @group.accounts
  end

  # POST /charges
  # POST /charges.json
  def create
    @charge = @group.charges.new(params[:charge])

    authorize! :create, @charge

    respond_to do |format|
      if @charge.save
        format.html { redirect_to group_charges_path(@group), notice: 'Charge was successfully created.' }
        format.json { render json: @charge, status: :created, location: @charge }
      else
        format.html { render action: "new" }
        format.json { render json: @charge.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /charges/1
  # PUT /charges/1.json
  def update
    @charge = Charge.find(params[:id])

    authorize! :update, @charge

    respond_to do |format|
      if @charge.update_attributes(params[:charge])
        format.html { redirect_to group_charges_path(@group), notice: 'Charge was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @charge.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /charges/1
  # DELETE /charges/1.json
  def destroy
    @charge = Charge.find(params[:id])

    authorize! :destroy, @charge
    flash[:notice] = "Charge was successfully destroyed" if @charge.destroy

    respond_to do |format|
      format.html { redirect_to group_charges_url(@group) }
      format.json { head :no_content }
    end
  end

  private

  def get_group
    @group = Group.find(params[:group_id])
    authorize! :read, @group
  end
end
