class ChangeTypeToPostTypeUserposts < ActiveRecord::Migration
  def change
    rename_column :userposts, :type, :post_type
  end
end
