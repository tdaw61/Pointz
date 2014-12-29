class ChangeLikePostToUserpost < ActiveRecord::Migration
  def change
    rename_column :likes, :post_id, :userpost_id
  end
end
