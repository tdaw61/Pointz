class SetScoreValueDefault < ActiveRecord::Migration
  def change
    change_column_default :scores, :points, 0
  end
end
