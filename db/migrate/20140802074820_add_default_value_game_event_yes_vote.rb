class AddDefaultValueGameEventYesVote < ActiveRecord::Migration
  def change
    change_column :game_events, :yes_votes, :integer, :default => 1

  end
end
