class AddCommentIdToLikes < ActiveRecord::Migration
  def change
    add_column :likes, :comment_id, :integer
  end
end
