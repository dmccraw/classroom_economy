class StudentsController < ApplicationController
  before_filter :get_group

  def index
    @students = @group.users.all

    # authorize! :read, @students.first

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @students }
    end
  end

  # GET /users/1
  # GET /users/1.json
  def show
    @student = @group.users.find(params[:id])

    authorize! :read, @student

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @student }
    end
  end

  # GET /users/new
  # GET /users/new.json
  def new
    @student = @group.users.new(user_type: User::USER_TYPE_STUDENT)

    authorize! :create, @student

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @student }
    end
  end

  # GET /users/1/edit
  def edit
    @student = @group.users.find(params[:id])

    authorize! :update, @student
  end

  # POST /users
  # POST /users.json
  def create
    @student = @group.users.new(params[:user])

    authorize! :create, @student

    respond_to do |format|
      if @student.save
        Membership.create(user_id: @student.id, group_id: @group.id)

        format.html { redirect_to group_students_path(@group), notice: "#{@student.display_name} was successfully created." }
        format.json { render json: @student, status: :created, location: @student }
      else
        format.html { render action: "new" }
        format.json { render json: @student.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /users/1
  # PUT /users/1.json
  def update
    @student = @group.users.find(params[:id])

    authorize! :udpate, @student

    respond_to do |format|
      if @student.update_attributes(params[:user])
        format.html { redirect_to group_students_path(@group), notice: "#{@student.display_name} was successfully updated." }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @student.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /users/1
  # DELETE /users/1.json
  def destroy
    @student = @group.users.find(params[:id])

    authorize! :destroy, @student

    @student.destroy

    respond_to do |format|
      format.html { redirect_to group_students_path, notice: "#{@student.display_name} was successfully deleted." }
      format.json { head :no_content }
      format.js { render text: "location.reload(true);"}
    end
  end

  private

  def get_group
    @group = Group.find(params[:group_id])
  end
end