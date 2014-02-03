class ProjectsController < ApplicationController
  before_action :get_project,only: [:show,:destroy,:edit,:update,:redirect_if_not_owner]#except: [:index,:new,:destroy]
  #,only: [:show,:destroy,:manage_collaborators]
  before_action :redirect_if_not_owner, only: [:destroy,:edit,:update]
  
  def index
    @owned_projs=current_user.projects
    @member_projs=current_user.assigned_projects
  end

  def new
    @proj=current_user.projects.new
  end

  def create
    @proj=current_user.projects.new params.require(:project).permit([:title,:description])
    @proj.user=current_user
    @proj.members << current_user if params[:project][:collab]=='yes'
    if @proj.save
      redirect_to root_path
    else
      render :new
    end
  end

  def edit
    @users=User.all
  end

  def update
    @proj.update_attributes params.require(:project).permit([:title,:description,:user_id])
    if @proj.save
      redirect_to root_path
    else
      render :edit
    end
  end

  def show
    @tasks=@proj.tasks.order("completed asc")
    @discussions=@proj.discussions
  end

  def destroy
    id=@proj.id
    @proj.destroy
    redirect_to root_path, notice: "Project #{id} was removed."
  end

  private

  def redirect_if_not_owner
    if !current_user.can_modify_proj? get_project
      redirect_to root_path, alert: "You do not own project #{@proj.id}" 
    end
  end

end
