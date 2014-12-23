class AddActiveToLeague < ActiveRecord::Migration
  def change
    add_column :leagues, :active, :boolean, default: :true
  end
end
