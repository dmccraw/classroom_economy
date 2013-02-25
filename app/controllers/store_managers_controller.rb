class StoreManagersController < ApplicationController

  before_filter :get_group_and_store

  # GET /store_managers
  # GET /store_managers.json
  # def index
  #   @store_managers = group.StoreManager.all

  #   respond_to do |format|
  #     format.html # index.html.erb
  #     format.json { render json: @store_managers }
  #   end
  # end

  # GET /store_managers/1
  # GET /store_managers/1.json
  # def show
  #   @store_manager = StoreManager.find(params[:id])

  #   respond_to do |format|
  #     format.html # show.html.erb
  #     format.json { render json: @store_manager }
  #   end
  # end

  # GET /store_managers/new
  # GET /store_managers/new.json
  def new
    @store_manager = StoreManager.new(store_id: @store.id)
    @users = @group.users

    authorize! :create, @store_manager

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @store_manager }
    end
  end

  # GET /store_managers/1/edit
  # def edit
  #   @store_manager = StoreManager.find(params[:id])
  #   @users = @group.users
  # end

  # POST /store_managers
  # POST /store_managers.json
  def create
    @store_manager = StoreManager.new(params[:store_manager])
    @users = @group.users

    authorize! :create, @store_manager

    respond_to do |format|
      if @store_manager.save
        format.html { redirect_to group_store_path(@group, @store), notice: 'Store manager was successfully created.' }
        format.json { render json: @store_manager, status: :created, location: @store_manager }
      else
        format.html { render action: "new" }
        format.json { render json: @store_manager.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /store_managers/1
  # PUT /store_managers/1.json
  # def update
  #   @store_manager = StoreManager.find(params[:id])

  #   authorize! :udpate, @store_manager

  #   respond_to do |format|
  #     if @store_manager.update_attributes(params[:store_manager])
  #       format.html { redirect_to group_store_path(@group,@store), notice: 'Store manager was successfully updated.' }
  #       format.json { head :no_content }
  #     else
  #       format.html { render action: "edit" }
  #       format.json { render json: @store_manager.errors, status: :unprocessable_entity }
  #     end
  #   end
  # end

  # DELETE /store_managers/1
  # DELETE /store_managers/1.json
  def destroy
    @store_manager = StoreManager.find(params[:id])

    authorize! :destroy, @store_manager

    @store_manager.destroy
    respond_to do |format|
      format.html { redirect_to group_store_path(@group, @store_manager.store), notice: "Store Manager #{@store_manager.user.display_name} was removed." }
      format.json { head :no_content }
    end
  end

  private

  def get_group_and_store
    @group = Group.find(params[:group_id])
    @store = Store.find(params[:store_id])

    authorize! :read, @group
  end

end
