class ProjectAssignee < ActiveRecord::Base
  belongs_to :project
  belongs_to :user
  after_destroy :remove_tasks

  def remove_tasks
    Rails.logger.info "refuhigrejhgirtuh5vuh uh5uh4uh45 iu he"
    self.project.tasks.each do |t|
      t.assignees.destroy_all(user: self.user)
    end
  end

end
