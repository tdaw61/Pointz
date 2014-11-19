class AddActiveToGameEvents < ActiveRecord::Migration
  def change
    add_column :game_events, :active, :boolean, default: true
  end
end
