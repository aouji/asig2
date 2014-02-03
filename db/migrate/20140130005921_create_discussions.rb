class CreateDiscussions < ActiveRecord::Migration
  def change
    create_table :discussions do |t|
      t.text :title
      t.text :body
      t.references :task, index: true
      t.references :user, index: true

      t.timestamps
    end
  end
end
