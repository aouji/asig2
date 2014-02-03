class CreateTaskAssignees < ActiveRecord::Migration
  def change
    create_table :task_assignees do |t|
      t.references :task, index: true
      t.references :user, index: true

      t.timestamps
    end
  end
end
