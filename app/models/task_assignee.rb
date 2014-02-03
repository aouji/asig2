class TaskAssignee < ActiveRecord::Base
  belongs_to :task
  belongs_to :user
  # validate :project_membership_checker

  # def project_membership_checker
  #   errors.add(:user, " should be a project member.
  #     User #{self.user.id} is not.") unless self.user.assigned_projects.include? self.task.project
  # end

end
