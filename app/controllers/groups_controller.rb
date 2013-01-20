class GroupsController < ApplicationController

  # GET /groups
  # GET /groups.json
  def index
    if current_user.admin?
      @groups = Group.all
    else
      @groups = current_user.groups
    end

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @groups }
    end
  end

  # GET /groups/1
  # GET /groups/1.json
  def show
    @group = Group.find(params[:id])

    authorize! :read, @group

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @group }
    end
  end

  # GET /groups/new
  # GET /groups/new.json
  def new
    @group = Group.new
    @group.user_id = current_user.id

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @group }
    end
  end

  # GET /groups/1/edit
  def edit
    @group = Group.find(params[:id])
    unless @group.can_access?(current_user)
      redirect_to groups_path
      return
    end
  end

  # POST /groups
  # POST /groups.json
  def create
    @group = Group.new(params[:group])

    authorize! :create, @group

    respond_to do |format|
      if @group.save
        format.html { redirect_to @group, notice: 'Group was successfully created.' }
        format.json { render json: @group, status: :created, location: @group }
      else
        format.html { render action: "new" }
        format.json { render json: @group.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /groups/1
  # PUT /groups/1.json
  def update
    @group = Group.find(params[:id])

    authorize! :udpate, @group

    if @group.can_access?(current_user)
      respond_to do |format|
        if @group.update_attributes(params[:group])
          format.html { redirect_to @group, notice: 'Group was successfully updated.' }
          format.json { head :no_content }
        else
          format.html { render action: "edit" }
          format.json { render json: @group.errors, status: :unprocessable_entity }
        end
      end
    else
      respond_to do |format|
        format.html { redirect_to action: "index"}
        format.json { render json: nil }
      end
    end
  end

  # DELETE /groups/1
  # DELETE /groups/1.json
  def destroy
    @group = Group.find(params[:id])

    authorize! :delete, @group

    @group.destroy

    respond_to do |format|
      format.html { redirect_to root_path }
      format.json { head :no_content }
    end
  end

end
