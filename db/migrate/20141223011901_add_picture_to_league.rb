class AddPictureToLeague < ActiveRecord::Migration
  def change
    add_column :leagues, :picture, :string
  end
end
