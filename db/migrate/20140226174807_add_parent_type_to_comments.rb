class AddParentTypeToComments < ActiveRecord::Migration
  def change
    add_column :comments, :commentable_type, :string
    rename_column :comments, :discussion_id, :commentable_id
    add_index "comments", ["commentable_id","commentable_type"], name: "index_comments_on_commentable_id_and_type", using: :btree
    Comment.update_all(commentable_type: "Discussion")
  end
end
