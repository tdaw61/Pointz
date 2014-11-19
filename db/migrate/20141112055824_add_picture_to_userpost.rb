class AddPictureToUserpost < ActiveRecord::Migration
  def change
    add_column :userposts, :picture, :string
  end
end
