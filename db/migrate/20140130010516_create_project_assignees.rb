class CreateProjectAssignees < ActiveRecord::Migration
  def change
    create_table :project_assignees do |t|
      t.references :project, index: true
      t.references :user, index: true

      t.timestamps
    end
  end
end
