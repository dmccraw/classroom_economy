class StoresController < ApplicationController

  before_filter :get_group

  # GET /stores
  # GET /stores.json
  def index
    @stores = @group.stores.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @stores }
    end
  end

  # GET /stores/1
  # GET /stores/1.json
  def show
    @store = @group.stores.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @store }
    end
  end

  # GET /stores/new
  # GET /stores/new.json
  def new
    @store = @group.stores.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @store }
    end
  end

  # GET /stores/1/edit
  def edit
    @store = @group.stores.find(params[:id])

    authorize! :modify, @store
  end

  # POST /stores
  # POST /stores.json
  def create
    @store = @group.stores.new(params[:store])

    respond_to do |format|
      if @store.save
        if params[:user_id].present?
          StoreOwner.create(user_id: params[:user_id], store_id: @store.id)
          @user = User.find(params[:user_id])
          format.html { redirect_to group_stores_path(@group,@store), notice: 'Store was successfully created.' }
          format.json { render json: @store, status: :created, location: @store }
        else
          format.html { redirect_to group_stores_path(@group,@store), notice: 'Store was successfully created.' }
          format.json { render json: @store, status: :created, location: @store }
        end
      else
        format.html { render action: "new" }
        format.json { render json: @store.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /stores/1
  # PUT /stores/1.json
  def update
    @store = @group.stores.find(params[:id])

    authorize! :modify, @store

    respond_to do |format|
      if @store.update_attributes(params[:store])
        if params[:user_id].present?
          @user = User.find(params[:user_id])
          format.html { redirect_to group_stores_path(@group,@user), notice: 'Store was successfully updated.' }
          format.json { head :no_content }
        else
          format.html { redirect_to group_stores_path(@group,@user), notice: 'Store was successfully updated.' }
          format.json { head :no_content }
        end
      else
        format.html { render action: "edit" }
        format.json { render json: @store.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /stores/1
  # DELETE /stores/1.json
  def destroy
    @store = @group.stores.find(params[:id])

    authorize! :destroy, @store

    @store.destroy

    respond_to do |format|
      format.html { redirect_to group_stores_path(@group), notice: 'Store was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private

  def get_group
    @group = Group.find(params[:group_id])
  end
end
