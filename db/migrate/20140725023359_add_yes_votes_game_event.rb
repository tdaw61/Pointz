class AddYesVotesGameEvent < ActiveRecord::Migration
  def change
    add_column :game_events, :yes_votes, :integer
  end
end
