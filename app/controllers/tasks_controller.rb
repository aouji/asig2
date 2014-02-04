class TasksController < ApplicationController
  before_action :get_project
  before_action :get_task, only: [:show,:destroy,:edit,:update]

  def index
    @owned=@proj.tasks.where("user_id=?",current_user.id).order("completed")  # current_user.projects.find(@proj).tasks.order("completed asc")
    @assigned=current_user.assigned_tasks.where("project_id=?",@proj.id).order("completed")
    # current_user.projects.find(@proj).tasks.order("completed asc")
  end

  def new
    @task=current_user.tasks.new
  end

  def create
    @task=current_user.tasks.new params.require(:task).permit([:name,:description,:due])
    @task.project=@proj
    @task.assignees << current_user if params[:task][:assignee]=='yes'
    if @task.save
      redirect_to project_path(@proj)
    else
      render :new
    end
  end

  def destroy
    if (current_user.tasks.include? @task)
      @task.destroy
      redirect_to :back, notice: 'Task removed.'
    else
      redirect_to project_tasks_path @proj, alert: 'You do not own this task'
    end
  end

  def show
  end

  # def manage_collaborators
  #   @users=@proj.members
  #   render :collaborators_form
  # end

  # def add_remove_collaborators
  #   redirect_to root_path
  # end

  def edit
    @users=@proj.members
    @users.push(@proj.user) unless @proj.members.include? @proj.user
  end

  def update
    @task.update_attributes params.require(:task).permit([:name,:description,:due,:completed,:user_id])
    if @proj.save
      redirect_to project_task_path(@proj,@task)
    else
      render :edit
    end
  end

  private

  def get_task
    id=params[:task_id] || params[:id]
    begin 
      @task=@proj.tasks.find(id) if (@proj.user==current_user)
    rescue  ActiveRecord::RecordNotFound
      begin 
        @task=current_user.tasks.find(id)
      rescue ActiveRecord::RecordNotFound
        begin 
          @task=current_user.assigned_tasks.find(id)
        rescue ActiveRecord::RecordNotFound
          # TODO: redirect to 404 or maybe 401
          # redirect_to root_path
          redirect_to root_path, alert: "Task #{id} does not exist or you do not have access to it."
        end
      end
    end
  end

end
