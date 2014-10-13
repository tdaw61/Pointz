class AddTargetUserIdToUserposts < ActiveRecord::Migration
  def change
    add_column :userposts, :target_user_id, :integer
  end
end
