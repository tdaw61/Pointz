class AddLeagueIdToScores < ActiveRecord::Migration
  def change
    add_column :scores, :league_id, :integer
  end
end
