class AddScoreCapAndPointTiersToGames < ActiveRecord::Migration
  def change
    add_column :games, :score_cap, :integer
    add_column :games, :point_tiers, :integer
  end
end
