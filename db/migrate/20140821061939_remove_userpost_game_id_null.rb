class RemoveUserpostGameIdNull < ActiveRecord::Migration
  def change

    change_column_null :userposts, :game_id, true

  end
end
