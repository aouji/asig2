class Project < ActiveRecord::Base

  validates_presence_of :title
  validates_presence_of :description

  belongs_to :user
  has_many :tasks,dependent: :destroy

  has_many :project_assignees
  has_many :members,through: :project_assignees, source: :user
  has_many :discussions
  after_save :propogate_removed_users
 
  def propogate_removed_users
    # assignee_ids=[]
    # tasks.each do |task|
    #   assignee_ids+=task.task_assignees.pluck([:id])
    # end
    TaskAssignee.where(["task_id in (?)", tasks.pluck(:id)]).
                where(["task_assignees.user_id NOT IN (?)", members.pluck(:id)]).
                destroy_all
    # p assignee_ids
    #   task.task_assignees.each do |assignee|
    #     if !members.include? assignee
    #        assignee.destroy
    #     end
    #   end
    # end
  end

end
