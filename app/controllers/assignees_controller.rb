class AssigneesController < TasksController

 before_action :get_project
 before_action :get_task
 # before_action :member_form, only: [:update]
 # before_action :authenticate_user!
  def index
    @users=User.all
    render :collaborators_form
  end

  def update
    # p (params.require(:project).permit({member_ids:[]}))
    begin
      @task.update_attributes members_from_form
    rescue
      @users=User.all
      return render :collaborators_form, alert: 'Shoot'
    end
    redirect_to project_task_path(@proj,@task), notice: "Update successful."
  end

  def new
    index
  end

  def create
    update
  end

  private 

  def members_from_form
    # begin 
      # member_ids=
      (params.require(:task).permit({assignee_ids:[]}))
    # rescue ActionController::ParameterMissing
      # member_ids={member_ids: []}
    # end
    # member_ids
  end

end
