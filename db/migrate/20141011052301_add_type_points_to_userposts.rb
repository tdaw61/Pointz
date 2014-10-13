class AddTypePointsToUserposts < ActiveRecord::Migration
  def change
    add_column :userposts, :type, :string
    add_column :userposts, :points, :integer
  end
end
