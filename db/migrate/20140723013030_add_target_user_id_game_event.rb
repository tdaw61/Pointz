class AddTargetUserIdGameEvent < ActiveRecord::Migration
  def change
    add_column :game_events, :target_user_id, :integer
    add_column :game_events, :target_user_id, :time
  end
end
