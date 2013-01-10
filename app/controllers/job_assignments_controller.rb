class JobAssignmentsController < ApplicationController

  before_filter :get_group

  # GET /jobs/new
  # GET /jobs/new.json
  def new
    @job_assignment = @group.job_assignments.new
    @jobs = @group.jobs.order("title")
    @users = @group.users.order("first_name")

    if params[:job_id].present?
      @job = Job.find(params[:job_id])
    end

    if params[:user_id].present?
      @user = User.find(params[:user_id])
    end

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @job_assignment }
    end
  end

  # POST /jobs
  # POST /jobs.json
  def create
    @jobs = @group.jobs
    @users = @group.users

    if params[:job_id].present?
      @job = Job.find(params[:job_id])
    end

    if params[:user_id].present?
      @user = User.find(params[:user_id])
    end

    @job_assignment = @group.job_assignments.new(params[:job_assignment])

    respond_to do |format|
      if @job_assignment.save
        format.html { redirect_to group_jobs_path(@group), notice: 'Job assignment was successfully created.' }
        format.json { render json: @job_assignment, status: :created, location: @job_assignment }
      else
        format.html { render action: "new" }
        format.json { render json: @job_assignment.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /jobs/1
  # DELETE /jobs/1.json
  def destroy
    @job_assignment = @group.jobs.find(params[:id])
    @job_assignment.destroy

    respond_to do |format|
      format.html { redirect_to group_jobs_path(@group) }
      format.json { head :no_content }
    end
  end

  private

  def get_group
    @group = Group.find(params[:group_id])
  end

end
