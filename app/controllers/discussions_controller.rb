class DiscussionsController < ApplicationController
  before_action :get_project
  before_action :get_discussion, only: [:show,:destroy,:edit,:update]

  def index
    # @owned=current_user.discussions
    # @owned=@proj.discussions.where("user_id=?",current_user.id)   # current_user.projects.find(@proj).tasks.order("completed asc")
    # @proj_discussions=@proj.discussions
    super.show
  end

  def new
    @discussion=current_user.discussions.new
  end

  def create
    @discussion=current_user.discussions.new params.require(:discussion).permit([:title,:body])
    @discussion.project=@proj
    if @discussion.save
      redirect_to project_path(@proj)
    else
      render :new
    end
  end

  def destroy
    if (current_user.discussions.include? @discussion)
      @discussion.destroy
      redirect_to project_path(@proj)
    else
      redirect_to :back, alert: 'You do not own this discussion'
    end
  end

  def show
    @comments=@discussion.comments
    @comment=Comment.new
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
    @discussion.update_attributes params.require(:discussion).permit([:title,:body,:user_id])
    if @proj.save
      redirect_to project_discussion_path(@proj,@discussion)
    else
      render :edit
    end
  end

  private

  # def get_disc_params
  #   params.require(:discussion).permit([:title,:body])
  # end


  def get_discussion
    # get_project
    id=params[:discussion_id] || params[:id]
    begin 
      @discussion=@proj.discussions.find(id)
    rescue  ActiveRecord::RecordNotFound
          # TODO: redirect to 404 or maybe 401
          # redirect_to root_path
          redirect_to root_path, alert: "Discussion #{id} does not exist or you do not have access to it."
    end
  end

end
