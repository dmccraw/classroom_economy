class StoreOwnersController < ApplicationController

  before_filter :get_group_and_store

  # GET /stores/new
  # GET /stores/new.json
  def new
    @store_owner = StoreOwner.new(store_id: @store.id)
    @users = @group.users

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @store_owner }
    end
  end

  # POST /stores
  # POST /stores.json
  def create
    @store_owner = StoreOwner.new(params[:store_owner])
    @users = @group.users

    respond_to do |format|
      if @store_owner.save
        format.html { redirect_to group_store_path(@group,@store), notice: 'Store Owner was successfully created.' }
        format.json { render json: @store_owner, status: :created, location: @store_owner }
      else
        format.html { render action: "new" }
        format.json { render json: @store_owner.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /stores/1
  # DELETE /stores/1.json
  def destroy
    @store_owner = StoreOwner.find(params[:id])

    # authorize! :destroy, @store_owner

    @store_owner.destroy

    respond_to do |format|
      format.html { redirect_to group_store_path(@group, @store), notice: 'Store Owner was removed.' }
      format.json { head :no_content }
    end
  end

  private

  def get_group_and_store
    @group = Group.find(params[:group_id])
    @store = Store.find(params[:store_id])
  end

end
