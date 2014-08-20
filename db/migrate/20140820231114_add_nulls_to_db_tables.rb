class AddNullsToDbTables < ActiveRecord::Migration
  def change
    change_column_null :leagues, :name, false
    change_column_null :userposts, :data, false
    change_column_null :userposts, :user_id, false
    change_column_null :userposts, :game_id, false
    change_column_null :users, :email, false
    change_column_null :games, :league_id, false
    change_column_null :games, :name, false
    change_column_null :game_events, :game_id, false
    change_column_null :game_events, :user_id, false
    change_column_null :game_events, :target_user_id, false
    change_column_null :game_events, :point_value, false
    change_column_null :event_votes, :game_id, false
    change_column_null :event_votes, :user_id, false
  end
end
