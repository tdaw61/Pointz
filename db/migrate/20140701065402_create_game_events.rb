class CreateGameEvents < ActiveRecord::Migration
  def change
    create_table :game_events do |t|

      t.integer :point_value
      t.string :data
      t.references :game, :index => true
      t.references :user, :index => true

      t.timestamps
    end

  end
end
