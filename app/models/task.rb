class Task < ActiveRecord::Base
  belongs_to :project
  belongs_to :user
  has_many :task_assignees
  has_many :assignees, through: :task_assignees, source: :user
  validate :due_date_checker
  # has_many :task_assignees, through: :, source: 

  has_many :comments, as: :commentable,dependent: :destroy
  has_many :commenters, through: :comments, source: :user

  def due_date_checker
    if !due.present? || due < Date.today
      errors.add(:due, " date should be filled and should be in the future.")
    end
  end

  def complete?
    self.completed ? 'Completed' : 'In Progress'
  end
end
