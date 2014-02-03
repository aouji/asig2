class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
  has_many :projects
  has_many :assigned_projects, through: :project_assignees,source: :project
  
  has_many :project_assignees

  has_many :tasks
  has_many :assigned_tasks, through: :task_assignees,source: :task

  has_many :task_assignees

  has_many :discussions
  has_many :comments

  def can_modify_proj? proj
    true if id==proj.user_id
  end

  def can_modify_comment? comment
    true if id==comment.user_id
  end

  def can_modify_task? task
    true if id==task.user_id
  end 

  def can_finish_task? task
    true if (can_modify_task?(task) || task.assignees.include?(self))
  end

  def can_modify_discussion? discussion
    true if id==discussion.user_id
  end

end
