class CreateTasks < ActiveRecord::Migration
  def change
    create_table :tasks do |t|
      t.text :name
      t.text :description
      t.date :due
      t.boolean :completed, default: false
      t.references :project, index: true
      t.references :user, index: true

      t.timestamps
    end
  end
end
