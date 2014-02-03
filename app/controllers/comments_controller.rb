class CommentsController < DiscussionsController
  before_action :get_discussion
  before_action :get_comment,only: [:show,:destroy,:edit,:update]

  def index
    # @owned=@discussion.comments.where("user_id=?",current_user.id).order("created_at")
    @comments=@discussion.comments.order("created_at")
    @comment=@discussion.comments.new
    render 'discussions/show'
  end

  def new
    @comment=current_user.comments.new
  end

  def create
    @comment=current_user.comments.new get_comment_params
    @comment.discussion=@discussion
    if @comment.save
      redirect_to project_discussion_path(@proj,@discussion)
    else
      render :new
    end
  end

  def destroy
    if (current_user.comments.include? @comment)
      @comment.destroy
      redirect_to project_discussion_path(@proj,@discussion)
    else
      redirect_to :back, alert: 'You do not own this comment'
    end
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
    @comment.update_attributes get_comment_params
    if @proj.save
      redirect_to project_discussion_path(@proj,@discussion)
    else
      render :edit
    end
  end

  private

   def get_comment_params
     params.require(:comment).permit([:body])
   end


  def get_comment
    # get_discussion
    id=params[:comment_id] || params[:id]
    begin 
      @comment=@discussion.comments.find(id)
    rescue  ActiveRecord::RecordNotFound
          # TODO: redirect to 404 or maybe 401
          # redirect_to root_path
          redirect_to root_path, alert: "Comment #{id} does not exist or you do not have access to it."
    end
  end

end