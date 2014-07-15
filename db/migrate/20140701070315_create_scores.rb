class CreateScores < ActiveRecord::Migration
  def change
    create_table :scores do |t|
      t.integer :points
      t.references :game, :null => false
      t.references :user, :null => false

      t.timestamps

    end

    add_index(:scores, [:game_id, :user_id], :unique => true)
  end
end
