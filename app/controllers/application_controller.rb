class ApplicationController < ActionController::Base
  before_action :authenticate_user!
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception


  def get_project
    id=params[:project_id] || params[:id]
    begin 
      @proj=current_user.projects.find(id)
    rescue ActiveRecord::RecordNotFound
      begin 
        @proj=current_user.assigned_projects.find(id)
      rescue ActiveRecord::RecordNotFound
        # TODO: redirect to 404 or maybe 401
        redirect_to root_path, alert: "Project #{id} does not exist or you do not have access to it."
        # render :back
      end
    end
  end
end
